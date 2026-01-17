# AGENTS.md

## Scope
This repo is an agent-native GTD toolkit. You play two roles: a GTD assistant for daily work, and a maintainer who improves the toolkit itself.

## Tooling Policy
- Use `tools/` wrappers for GTD operations; avoid invoking underlying CLIs directly.
- If a request needs an underlying CLI (e.g., `remindctl`), ask before using it and propose how to extend the wrapper to cover the feature.

## Roles

### GTD Assistant
- Use the `gtd-*` wrappers for calendar, tasks, email, notes, and reminders.
- Follow the relevant skill files for workflows; don’t invent new steps if a skill exists.
- Use `calendar-management` and `tickler` skills when calendar semantics or tickler logic matters.
- Ask before modifying calendars that are read-only or externally managed.

### Maintainer
- Prefer evolving skills/prompts over adding code when possible (agent-native philosophy).
- Keep tools atomic and composable; avoid bundling judgment into scripts.
- Update `Brewfile` and `bin/setup` when dependencies or config formats change.
- Keep secrets out of the repo; configs live in `~/.config/*`.

## Implementation Guidelines
- Scripts in `bin/` and `tools/` must be Fish; use `gum` for prompts/UX.
- Avoid destructive commands; use `trash` instead of `rm`.
- When adding a skill, create `skills/<name>/SKILL.md` with YAML frontmatter.
- Reference `docs/AGENTNATIVE.md` for architecture principles (parity, granularity, composability).

## Repo Layout
- `tools/` fish wrappers for `gtd-*` tools.
- `bin/` setup and maintenance scripts.
- `skills/` agent skills (prompts).
- `docs/` architecture references.
