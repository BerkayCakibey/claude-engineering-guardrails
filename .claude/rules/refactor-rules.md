# Refactoring Rules

Guidelines for safe, incremental code refactoring.

---

## Core Principle

> **Refactor in tiny steps. Keep refactoring separate from feature changes. Use Git checkpoints only when the user and workflow explicitly call for them.**

---

## Pre-Refactoring Checklist

Before starting any refactor:

- [ ] **Tests Exist** - Unit tests cover the code being refactored
- [ ] **Tests Pass** - Current state is green
- [ ] **Optional Checkpoint** - If your workflow uses Git checkpoints, create a user-approved commit or tag
- [ ] **Scope Defined** - Clear understanding of what changes and what doesn't
- [ ] **Rollback Plan** - Know how to undo if something breaks

---

## Refactoring Principles

### 1. Single Responsibility

```python
# ❌ BAD - Does two things
def process_and_send_email(user):
    body = generate_email_body(user)  # Logic
    send_email(user.email, body)    # Side effect
    return body

# ✅ GOOD - Separate concerns
def generate_email_body(user):
    return f"Hello {user.name}"

def send_welcome_email(user):
    body = generate_email_body(user)
    send_email(user.email, body)
```

### 2. Small Steps

```
BAD:   Refactor entire authentication system in one go

GOOD:  Day 1: Extract user validation
       Day 2: Extract token generation  
       Day 3: Extract session management
       Day 4: Add tests for each component
```

### 3. Leave Code Cleaner

```
Rule: For every refactor, fix at least one:
- Naming (variable, function, class)
- Comment (outdated, missing)
- Structure (duplication, complexity)
```

---

## Refactoring Patterns

### Extract Function

```python
# BEFORE - Inline code in loop
for order in orders:
    # Email logic duplicated
    if order.total > 1000:
        subject = f"Big order: {order.total}"
        body = f"Thank you for {order.total}"
        send_email(order.customer.email, subject, body)
    else:
        send_email(order.customer.email, "Order received", "Thank you")

# AFTER - Extracted function
def send_order_notification(order):
    if order.total > 1000:
        send_email(
            order.customer.email,
            f"Big order: {order.total}",
            f"Thank you for {order.total}"
        )
    else:
        send_email(
            order.customer.email,
            "Order received",
            "Thank you"
        )

for order in orders:
    send_order_notification(order)
```

### Replace Conditional with Early Return

```python
# BEFORE - Nested conditionals
def process_user(user):
    if user:
        if user.is_active:
            if user.has_permission:
                # Do something
                pass

# AFTER - Early returns
def process_user(user):
    if not user:
        return
    if not user.is_active:
        return
    if not user.has_permission:
        return
    # Do something
```

### Introduce Parameter Object

```python
# BEFORE - Long parameter list
def create_report(start_date, end_date, format, include_charts, include_summary, user_id):
    pass

# AFTER - Parameter object
@dataclass
class ReportRequest:
    start_date: date
    end_date: date
    format: str = "pdf"
    include_charts: bool = True
    include_summary: bool = True

def create_report(request: ReportRequest):
    pass
```

---

## When NOT to Refactor

- ❌ **Production incident active** - Fix the incident first
- ❌ **Deadline pressure** - Refactoring + features = bugs
- ❌ **No test coverage** - Write tests first
- ❌ **Unfamiliar code** - Understand first, refactor second
- ❌ **Working on different feature** - Keep refactors separate

---

## Refactoring vs. Rewriting

| Factor | Refactor | Rewrite |
|--------|----------|---------|
| Coverage | Tests exist | No tests |
| Scope | Clear boundaries | Blurry/risky |
| Time | < 1 week | > 1 week |
| Risk | Low | High |

**Rule:** If rewrite would take > 1 week, don't do it. Incremental refactor instead.

---

## Commit Messages for Refactors

If your workflow uses Git commits for checkpoints or handoff, prefer specific
messages over generic ones.

```bash
# Good examples
git commit -m "refactor: extract email validation to validate_email()"
git commit -m "refactor: replace nested conditionals with early returns"
git commit -m "refactor: introduce ReportRequest parameter object"

# Bad examples  
git commit -m "refactoring stuff"
git commit -m "fix"
git commit -m "cleanup"
```

---

## Post-Refactoring Checklist

After completing refactor:

- [ ] **All tests pass** - Including new tests for extracted code
- [ ] **Coverage maintained** - Not decreased
- [ ] **No linter warnings** - Code is clean
- [ ] **Behavior unchanged** - Tests prove same output
- [ ] **Documentation updated** - If needed

---

## Tools for Safe Refactoring

| Tool | Purpose |
|------|---------|
| `git stash` | Save changes temporarily |
| `git diff` | Review changes before commit |
| IDE refactor | Rename, extract, inline |
| `pytest --picked` | Run tests related to changed files |
| `ruff --fix` | Auto-fix style issues |
