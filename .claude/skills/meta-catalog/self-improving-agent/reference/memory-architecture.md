# Knowledge Architecture

A complete reference for how the project's knowledge systems work together.

## Three Memory Systems

### 1. CLAUDE.md Files (You → Claude)

**Purpose:** Persistent instructions you write to guide Claude's behavior.

**Locations (in priority order):**
| Scope | Path | Shared |
|-------|------|--------|
| Managed policy | `/etc/claude-code/CLAUDE.md` (Linux) | All users |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team (git) |
| User | `~/.claude/CLAUDE.md` | Just you |
| Local | `./CLAUDE.local.md` | Just you |

**Loading:** Full file, every session. Files higher in the directory tree load first.

**Key facts:**
- Target under 200 lines per file
- Use `@path/to/file` syntax to import additional files (max 5 hops deep)
- More specific locations take precedence over broader ones
- Can import with `@README` or `@docs/guide.md`
- CLAUDE.local.md is auto-added to .gitignore

### 2. Knowledge Files (Curated Notes)

**Purpose:** Project learnings, patterns, and debugging notes curated by you and the self-improving agent.

**Location:** Optional local `.claude/knowledge/`

**Structure:**
```
.claude/knowledge/
├── patterns.md        # Recognized patterns and conventions
├── debugging.md       # Debugging solutions and error patterns
├── architecture.md    # Architecture decisions and notes
└── ...                # More topic files as needed
```

**Key facts:**
- Organized by topic into separate files
- Loaded on demand by the self-improving agent
- User-owned local state by default; keep it ignored or otherwise manage it
  intentionally in your own setup
- Can be promoted to CLAUDE.md or .claude/rules/ when patterns prove durable

**What it captures:**
- Build commands and test conventions
- Debugging solutions and error patterns
- Code style preferences and architecture notes
- Your communication preferences and workflow habits

### 3. Session Memory (Claude → Claude)

**Purpose:** Conversation summaries for cross-session continuity.

**Location:** Optional local `.claude/knowledge/` (project-scoped, user-managed)

**Key facts:**
- Saves what was discussed and decided in specific sessions
- "What did we do yesterday?" context
- Loaded contextually (relevant past sessions, not all)
- Use `/si-remember` to save insights as permanent project knowledge

### 4. Rules Directory (You → Claude, scoped)

**Purpose:** Modular instructions scoped to specific file types.

**Location:** `.claude/rules/*.md`

**Key facts:**
- Uses YAML frontmatter with `paths` field for scoping
- Only loads when Claude works with matching files
- Recursive — can organize into subdirectories
- Same priority as `.claude/CLAUDE.md`
- Great for keeping CLAUDE.md under 200 lines

```yaml
---
paths:
  - "src/api/**/*.ts"
---
# API rules only load when working with API files
```

## Memory Priority

When entries conflict:

1. CLAUDE.md (highest — explicit instructions)
2. `.claude/rules/` (high — scoped instructions)
3. Knowledge files (medium — curated patterns)
4. Session context (low — historical context)

## The Self-Improving Agent's Role

```
Knowledge captures → This plugin curates → CLAUDE.md enforces

.claude/knowledge/  →  /si:review (analyze)  →  /si:promote (graduate)
                                                           ↓
                                                     CLAUDE.md or
                                                     .claude/rules/
                                                     (enforced rules)
```

**Why this matters:** Knowledge file entries are background context available on demand. CLAUDE.md entries are high-priority instructions loaded in full. Promoting a pattern from knowledge files to rules fundamentally changes how Claude treats it.

## Capacity Planning

| File | Soft limit | Hard limit | What happens at limit |
|------|-----------|------------|----------------------|
| CLAUDE.md | 150 lines | 200 lines | Adherence decreases with length |
| Knowledge files | No hard limit | No hard limit | Organize into more topic files as needed |
| Rules files | No limit per file | No limit | Only loaded when paths match |

## Best Practices

1. **Keep knowledge files organized** — promote proven patterns, remove stale ones
2. **Keep CLAUDE.md under 200 lines** — split into rules/ if growing
3. **Don't duplicate** — if it's in CLAUDE.md, remove it from knowledge files
4. **Scope rules** — use `.claude/rules/` with paths for file-type-specific patterns
5. **Review quarterly** — knowledge files go stale after refactors
6. **Use /si:status** — monitor capacity before it becomes a problem
