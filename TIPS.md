# Tips for Effective Claude Code Usage

Practical lessons learned from real-world Claude Code workflows.

This repository is a component depot. Read this before copying large numbers of
skills, agents, commands, hooks, or MCP integrations into your main
`~/.claude/` setup.

---

## Planning

- **Always plan before implementing.** For large tasks, run a pre-plan phase first: gather the information the plan will need, then generate the full plan with that context.
- **Write plans to files, not just chat.** Context can be lost or truncated. A plan in a file can be re-read, refined, and resumed across sessions or model changes.
- **Track progress in the plan file.** Mark completed steps so you can pick up exactly where you left off if the session breaks or the model changes. A checkbox format (`- [ ]` / `- [x]`) works well for this.
- **Scope before you plan.** Before writing a plan, clarify what is in scope and what is not. A plan without scope boundaries inevitably expands.
- **Break large tasks into phases.** If a task takes more than 3 steps, split it into phases with clear delivery points between them. This prevents context loss and makes progress visible.

## Task Lifecycle

- **Tracker ticket ≠ AI prompt.** Jira/Linear holds the task definition. It does not hold the current repo state. Feed the AI both — ticket plus a snapshot of where the code actually is.
- **Snapshot means: branch, last few commits, uncommitted changes, open PRs — in the same format every time.** A standardized input beats a freeform status dump; the AI stops re-interpreting the shape on every turn. Missing inputs waste prompt turns and produce plans that don't match reality.
- **Separate the "open the task" prompt from the "execute the task" prompt.** They optimize for different things. One prompt that tries to do both does neither well.
- **Write AI-facing files for the AI.** Terse, jargon-loaded, context-short. Keep human onboarding prose in human-facing files. Mixing the two weakens both.
- **Think of a task as five stages: open → pull → plan → harden → execute.** Don't collapse them into one turn. Context shifts between stages and the output shifts with it.
- **Harden the plan before executing it.** Assume the first-pass plan is incomplete — it almost always is. Fill the gaps, resolve ambiguity, write decisions down. "I'll fix it while implementing" burns turns and drifts scope.
- **Archive execution plans; don't delete them.** `docs/task-plans/<ticket-id>.md` or similar. Six months later, "why did we do it this way?" is easier to answer from a saved plan than from `git log`.
- **Treat reusable context docs as local state.** Files like `.claude/knowledge/` are optional helpers in your own setup, not components every repo should ship or commit by default.

## Token Efficiency

- **Watch what gets loaded every message.** System prompt, CLAUDE.md, AGENTS.md, memory, conversation history — all re-sent per turn. Remove anything that isn't pulling its weight.
- **Don't let the AI search the repo blindly.** Give it direct file paths and repo structure instead. AI searches are expensive and imprecise — a targeted read saves significant tokens.
- **Use the right model and effort for each task.** Writing an email, finishing a small task, and designing architecture from scratch need different effort levels and models. Not everything requires max capability.
- **Be aware of your token budget per session.** Have a rough idea of how much work fits in one session. Getting cut off mid-task is frustrating — scope accordingly.
- **Be careful with global scope.** Don't install dozens of skills, agents, and MCP servers globally. Each one adds token overhead to every session, even when unused. Move unused skills to a depot repo and only keep project-relevant ones in `~/.claude/`.
- **Use `/compact` when context grows.** It summarizes conversation history and frees up token space mid-session. Use it before you hit the limit, not after.
- **Short is better than long for agent descriptions.** A 10-line agent description that clearly states when to use it beats a 50-line one that duplicates information already in the skill chain. Every token in an agent file is loaded on every turn.

## Automation

- **If you do something 3 times, automate it.** Create a skill, a hook, or a memory entry. Invest the time once and recoup it on every future run.
- **Pull useful patterns from open-source repos.** Hooks, skills, agents, new features — adopt what helps. But watch for overengineering: sometimes new features cause more harm than good.
- **Commands are cheap, skills are expensive.** A slash command that chains into existing skills costs almost nothing to maintain. A new skill that duplicates 80% of an existing one costs tokens forever. Prefer composition over creation.

## Safety

- **Never skip permission prompts.** Yes, approving every command is tedious. Use bell notifications (terminal bell hooks) to alert you when approval is needed, and always read the command before approving.
- **Keep the human in the loop for critical actions.** Send that email yourself. Run that push yourself. Apply that Terraform plan yourself. If the AI makes a mistake, you are responsible.
- **When a hook blocks, surface it immediately.** The model should stop, show the blocked command and the hook's exact reason, and wait for a human decision instead of trying alternate syntax.
- **Run security checks on your work.** Review generated code for vulnerabilities before shipping.
- **Guardrails are seatbelts, not airbags.** They reduce risk during normal operation. They are not a substitute for reviewing plans and validating changes.
- **Verify infrastructure changes before applying.** Always run `terraform plan` and review the output. Never pipe `curl | bash` into production. Review generated Kubernetes manifests before applying them.

## Skill Design

- **One purpose per skill.** A skill that does one thing well is worth ten skills that do many things poorly. If you find yourself writing "and also...", split it.
- **Trigger conditions matter more than content.** A brilliant skill that never fires is worse than a mediocre skill that fires at the right time. Write clear, specific trigger descriptions.
- **Reference docs belong in `references/`, not in SKILL.md.** Keep the main skill file lean and actionable. Put examples, templates, and reference material in subdirectories.
- **Test your skill chains end-to-end.** A skill that references another skill that references a command that references a non-existent file is a broken chain. Walk it before you ship it.
- **Prune the catalog regularly.** If a skill rarely triggers and adds little unique guidance, merge it, rewrite it, or archive it. A smaller sharp catalog beats a larger noisy one.

## Agent Design

- **Agents should own a clear role.** Some agents route work, while others execute focused work. In both cases, they should delegate repeatable workflow logic to skills and keep scope boundaries explicit.
- **Match the model to the task.** Simple routing and formatting: use Sonnet. Complex reasoning and multi-step planning: use Opus. Don't burn Opus turns on formatting tasks.
- **Set maxTurns appropriately.** 30 turns is enough for most tasks. Increase only for genuinely complex workflows. Decrease for simple routing to save tokens.

## Prompting

- **If you don't know how to ask, ask the AI.** It often knows the best way to phrase a request to itself. Use it as a meta-tool for improving your own prompts.
- **Be specific about output format.** "Write a function" is ambiguous. "Write a Python function that takes a list of strings and returns a dict mapping each string to its length, with type hints and a docstring" will get better results every time.
- **Give context, not instructions.** Instead of "don't make it broken," say "the function must handle empty inputs and return an empty dict, not raise an exception."

## Mindset

- **Verify outputs, but be practical about it.** Test critical paths. Cross-check important decisions. But don't review every line of a trivial change — calibrate effort to risk.
- **Don't become too dependent.** If your tokens run out or access is revoked tomorrow, you should still be able to work. Keep your own skills sharp.
- **Iterate, don't perfect.** Ship something that works, then improve it. A working draft in the repo beats a perfect idea in your head.
- **The best config is the one you maintain.** A complex 50-rule setup that you never update is worse than a simple 10-rule setup that you refine weekly. Start small, expand based on real needs.
