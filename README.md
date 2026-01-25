# gtd

[Agent-native](docs/AGENTNATIVE.md) GTD tools for real inboxes. This is Nate Berkopec's personal agent-native app. It is not a drop-in tool for others. It matches my stack: Todoist, Fastmail, and more. Use it to learn. The ideas can help other stacks.

> [!NOTE]
> This repo is early. The tools wrap other CLIs.

## Why

- I'm experimenting with agent-native applications.
- I'd like to try talking to an agent for GTD.
- The composability of agent-native workflows intrigues me.

## GTD Workflows This App Supports

We support all the classic GTD loops:

- Capture: collect items into inboxes.
- Clarify: decide what each item means.
- Organize: file items into lists and projects.
- Reflect: do daily scans and weekly reviews.
- Engage: pick work by context, time, and energy.
- Renegotiate: defer, delegate, drop, or re-scope.

## Tools

All tools use the `gtd-*` name. They live in `tools/`.

| Tool | Backend | Purpose |
| --- | --- | --- |
| `gtd-action` | `todoist` | Inbox, next actions, projects, waiting-for |
| `gtd-calendar` | `khal` + `vdirsyncer` | Fastmail calendar CRUD |
| `gtd-notes` | `macnotesapp` (`notes`) | Apple Notes reference + someday/maybe |
| `gtd-email` | `himalaya` | Fastmail email triage |
| `gtd-reminders` | `remindctl` | Reminders tickler file |

### Example Commands

- `gtd-action inbox`
- `gtd-action waiting`
- `gtd-calendar list 14`
- `gtd-notes someday`
- `gtd-email list --folder INBOX`
- `gtd-reminders due`

## Skills

Skills follow the Agent Skills spec. Each skill is a folder with a `SKILL.md`.

Validate skills with `skills-ref validate`.

## Storage Model

> [!IMPORTANT]
> Todoist is the source of truth for actions.

### Todoist

- Inbox: unprocessed captures.
- Next Actions: tasks inside projects, tagged with contexts.
- Projects: Todoist hierarchy.
- Waiting For: priority `P4` (example: "Waiting: John to send report").
- Priority: `P4` waiting/blocked, `P3` workable, `P1/P2` unused.
- Contexts: Todoist labels (discover via `gtd-action labels`).

### Fastmail Calendar

- Full CRUD via `gtd-calendar` (khal + vdirsyncer).

### Apple Notes

- Reference: title + raw text only.
- Someday/Maybe: note must include `#somedaymaybe`.

### Reminders

- Tickler file only (not an inbox).

### Inboxes

1. Todoist inbox (`gtd-action`).
2. Email (`gtd-email`).
3. Physical inbox (agent prompts you).
4. `~/Documents/Inbox` (filesystem).

## Install and Setup

Run `bin/setup` to install dependencies and generate configs (prompts for secrets and previews each file before writing).

## Repo Layout

- `tools/`: Ruby CLI wrappers for `gtd-*` tools.
- `lib/gtd/`: Ruby implementation of each tool's CLI.
- `test/`: Unit and integration tests (minitest).
- `bin/`: setup and maintenance scripts.
- `skills/`: Agent Skills spec directories.
- `docs/*`: agent-native reference, gtd notes.
- `SPEC.md`: product plan and decisions.
- `TODO.md`: setup checklist.
- `mise.toml`: adds `./tools` to `PATH` and loads `.env`.

## Contributing

- Use `skills-ref validate` when you change skills.
- The CLI tools are written in Ruby with comprehensive test coverage.
- Keep files under ~100 lines; split into modules as needed.
- Run `bundle exec rake test` to run all tests.

## Design Decisions

- Tools are small; workflows live in skills.
- Tool output is plain text.
- No local storage beyond temp parsing, source of truth is in the tools.
