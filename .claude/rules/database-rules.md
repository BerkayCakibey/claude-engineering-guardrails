# Database Operation Rules

Safety rules for database migrations, queries, and schema changes.

---

## Migration Safety

Unless noted otherwise, the SQL examples below use PostgreSQL syntax. Verify
engine-specific behavior before copying statements into MySQL, SQL Server, or
other database environments.

### Golden Rules

1. **Backup First** - Every migration must have a verified backup
2. **Reversible Changes** - Every migration must have UP and DOWN
3. **Zero-Downtime** - Minimize lock time on live tables
4. **Test on Replica** - Validate on staging/replica before production

---

### Backup Checklist

Before ANY database change:

```bash
# PostgreSQL
pg_dump -Fc mydb > backup_$(date +%Y%m%d_%H%M%S).dump

# MySQL
mysqldump mydb > backup_$(date +%Y%m%d_%H%M%S).sql

# MongoDB
mongodump --archive=backup_$(date +%Y%m%d_%H%M%S).archive
```

**Verification:**
- [ ] Backup created successfully
- [ ] Backup file size is reasonable
- [ ] Backup can be read by restoration tool

---

### PostgreSQL Migration Template

```sql
-- Migration: 001_add_users_table.sql

-- UP Migration
BEGIN;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for email lookups
CREATE INDEX idx_users_email ON users(email);

-- DOWN Migration  
DROP INDEX idx_users_email;
DROP TABLE users;

COMMIT;
```

---

## Zero-Downtime Migrations

### PostgreSQL Example: Adding a Column

```sql
-- Step 1: Add nullable column (instant)
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Step 2: Backfill data (in batches)
UPDATE users SET phone = 'unknown' WHERE phone IS NULL;

-- Step 3: Add NOT NULL constraint (fast with default)
ALTER TABLE users ALTER COLUMN phone SET DEFAULT 'unknown';
ALTER TABLE users ALTER COLUMN phone SET NOT NULL;

-- Step 4: Add constraint validation
-- (Only if needed - requires exclusive lock)
-- ALTER TABLE users ADD CONSTRAINT phone_format CHECK (phone ~ '^[0-9]+$');
```

### PostgreSQL Example: Adding an Index

```sql
-- PostgreSQL: CONCURRENTLY avoids locks
CREATE INDEX CONCURRENTLY idx_orders_user_id ON orders(user_id);

-- MySQL: Use pt-online-schema-change for large tables
-- Or add in low-traffic window

-- DOWN
DROP INDEX CONCURRENTLY IF EXISTS idx_orders_user_id;
```

### PostgreSQL Example: Renaming a Column

```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN full_name VARCHAR(200);

-- Step 2: Backfill
UPDATE users SET full_name = first_name || ' ' || last_name;

-- Step 3: Add triggers for live updates
CREATE OR REPLACE FUNCTION sync_full_name()
RETURNS TRIGGER AS $$
BEGIN
  NEW.full_name = COALESCE(NEW.first_name, '') || ' ' || COALESCE(NEW.last_name, '');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_full_name_sync
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION sync_full_name();

-- Step 4: Swap column names (metadata only, fast)
ALTER TABLE users RENAME COLUMN full_name TO name_new;
ALTER TABLE users RENAME COLUMN name TO name_old;
ALTER TABLE users RENAME COLUMN name_new TO name;
DROP TRIGGER users_full_name_sync ON users;
ALTER TABLE users DROP COLUMN name_old;
```

---

## Query Safety

### Dangerous Patterns - NEVER DO

```sql
-- ❌ NEVER - Delete without WHERE
DELETE FROM users;  -- ALL DATA GONE

-- ❌ NEVER - UPDATE without WHERE  
UPDATE users SET active = false; -- ALL USERS DEACTIVATED

-- ❌ NEVER - DROP without backup
DROP TABLE users;

-- ❌ NEVER - TRUNCATE with dependencies
TRUNCATE users CASCADE; -- May break foreign keys

-- ❌ NEVER - ALTER large table in peak hours
ALTER TABLE orders ADD COLUMN new_col VARCHAR(100); -- Locks table
```

### Safe Patterns

```sql
-- ✅ ALWAYS - Use WHERE
DELETE FROM users WHERE id = '123';

-- ✅ ALWAYS - Use transactions
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 'from';
UPDATE accounts SET balance = balance + 100 WHERE id = 'to';
-- Verify totals match
SELECT 
  (SELECT SUM(balance) FROM accounts) = (SELECT SUM(initial_balance) FROM accounts)
  AS balanced;
COMMIT;
-- On error: ROLLBACK;

-- ✅ ALWAYS - EXPLAIN before new index
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = '123';

-- ✅ ALWAYS - Limit UPDATE/DELETE
-- MySQL example
UPDATE users SET last_login = NOW() WHERE last_login IS NULL LIMIT 1000;

-- PostgreSQL example
WITH batch AS (
  SELECT ctid
  FROM users
  WHERE last_login IS NULL
  LIMIT 1000
)
UPDATE users
SET last_login = NOW()
WHERE ctid IN (SELECT ctid FROM batch);
```

---

## Rollback Checklist

Before executing migration:

- [ ] **Backup Created** - Verified working backup exists
- [ ] **Rollback Script Ready** - DOWN migration written and tested
- [ ] **Downtime Window** - If needed, communicated to stakeholders
- [ ] **Monitoring Set** - Alerts configured for error spikes
- [ ] **Person Available** - Someone ready to assist if issues arise

---

## Index Guidelines

### When to Add Indexes

- Query runs frequently (100+ times/day)
- `EXPLAIN` shows sequential scan on large table
- Query is user-facing (latency sensitive)

### When NOT to Add

- Table is small (<1000 rows)
- Query is admin-only (runs rarely)
- Index would duplicate existing index
- Write-heavy table (index slows writes)

### Index Naming

```
idx_<table>_<column(s)>
idx_users_email
idx_orders_user_id_created_at
```

---

## Schema Review Rules

Before creating/modifying tables:

1. **Primary Key** - UUID vs BIGINT tradeoffs
2. **Indexes** - Which queries need acceleration?
3. **Foreign Keys** - Cascade behavior defined?
4. **Constraints** - NOT NULL, UNIQUE, CHECK
5. **Defaults** - Will new columns break app?
6. **Timestamps** - created_at, updated_at, deleted_at

---

## Data Migration Rules

When migrating data between systems:

1. **Extract** - Pull data from source
2. **Transform** - Clean and normalize
3. **Validate** - Check integrity
4. **Load** - Insert into target
5. **Verify** - Compare counts and sums

```bash
# Verify record counts
psql -d source -c "SELECT COUNT(*) FROM users" > /tmp/source_count
psql -d target -c "SELECT COUNT(*) FROM users" > /tmp/target_count
diff /tmp/source_count /tmp/target_count

# Verify sum of balances
psql -d source -c "SELECT SUM(balance) FROM accounts"
psql -d target -c "SELECT SUM(balance) FROM accounts"
```
