---
name: database-task
description: Database operations: migrations, queries, schema changes, index optimization. Usage: /database-task <operation>
---

# /database-task

Structured database development workflow with rollback safety.

## Usage

```
/database-task migration "add users table"
/database-task query "optimize slow query"  
/database-task schema "add index to orders"
/database-task backup "before migration"
```

## Workflow

### 1. Safety First

- Always create backup before changes
- Plan rollback strategy
- Never modify production without explicit approval

### 2. Review Schema

- Show current schema
- Explain impact of changes
- Identify dependencies

### 3. Migration Script

- Generate migration with UP and DOWN
- Include validation queries
- Add checks for data integrity

### 4. Testing

- Test in staging/replica first
- Verify rollback works
- Check performance impact

## Rules

- **NEVER** modify production without verified backup
- **ALWAYS** include rollback script
- **ALWAYS** test on replica first
- **USE** transactions for multi-step changes
- **NEVER** use `DROP` without verification
- **ALWAYS** use `EXPLAIN ANALYZE` before adding indexes

## Common Scenarios

### New Table
```
1. Write migration with all constraints
2. Add indexes for foreign keys
3. Include seed data if needed
4. Test rollback
```

### Schema Change
```
1. Add nullable column first
2. Backfill data
3. Add NOT NULL constraint
4. Add indexes
```

### Index Creation
```
1. Check query plan with EXPLAIN
2. Create index CONCURRENTLY (PostgreSQL)
3. Verify index is used
4. Monitor performance
```

## Skill Chain

For medium+ effort database tasks:

1. **repo-navigator** — locate schema files, migration directories, ORM models
2. **database-rules** (rule) — apply database safety policy
3. **self-check** — validate migration correctness after creation

For high-effort tasks (complex schema changes, performance optimization):
4. **test-strategy-planner** — design test strategy for migrations
5. **code-reviewer** — review migration scripts before execution
