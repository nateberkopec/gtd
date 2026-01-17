# Plan

We are building an agent-native (see AGENTNATIVE.md) GTD workflow assistant.

The idea is to build an agent-native application which helps a user complete the many ideas and processes of Getting Things Done by David Allen.

Those workflows include:

- Capture: Collecting random items which have the user's attention into the Inbox
- Clarify: Processing inbox
- Organize (Put where it belongs): File results into the right lists/places: Next Actions by context, Projects, Waiting For, Calendar, Someday/Maybe, Reference.
- Reflect (Review loops):
  - Daily / frequent: Quick scan of calendar and Next Actions; keep today under control.
  - Weekly Review: The deep reset: empty inboxes, update Projects list, review Waiting For, Someday/Maybe, calendar past/future, make sure every project has a next action.
- Engage (Do the work): Choose what to do from trusted lists using context/time/energy/priority. (This is the "execution" workflow.)
- Renegotiate (When reality changes): Re-clarify and re-commit: defer, delegate, drop, or break down actions/projects when you're overloaded.

## Tools

All tools use `gtd-*` naming. None are installed yet — installation is part of the work.

| Tool | Backend | Purpose |
|------|---------|---------|
| `gtd-action` | [sachaos/todoist](https://github.com/sachaos/todoist) | Todoist: inbox, next actions, projects, waiting-for |
| `gtd-calendar` | khal + vdirsyncer | Fastmail calendar, full CRUD |
| `gtd-notes` | [macnotesapp](https://github.com/RhetTbull/macnotesapp) | Apple Notes: reference, someday/maybe |
| `gtd-email` | TBD | Fastmail: read/archive/delete/move |
| `gtd-reminders` | reminders CLI (Homebrew) | Tickler file |
| filesystem | built-in agent tools | ~/Documents/Inbox |

## Skills

Skills follow the [Agent Skills specification](https://agentskills.io/specification), an open format for extending AI agent capabilities with specialized knowledge and workflows. Each skill is a directory containing a `SKILL.md` file with YAML frontmatter (name, description, license, metadata) plus Markdown instructions. Skills can optionally include `scripts/` for executable code, `references/` for additional documentation, and `assets/` for static resources like templates. The format uses progressive disclosure for token efficiency: lightweight metadata loads at startup, full instructions load when activated, and supporting resources load on demand.

The spec emphasizes simplicity and composability. Skill names are lowercase with hyphens (1-64 chars), descriptions explain what the skill does and when to use it (up to 1024 chars), and the main `SKILL.md` should stay under 500 lines. Instructions include step-by-step workflows, examples, and edge cases. Skills reference other files via relative paths. We will use `skills-ref validate` to validate our skills during development.

Skills can compose other skills.

### Primitive Skills (composable building blocks)

- **Clarify item**: Interview to understand what something is
- **Assign context**: Suggest/confirm context tags
- **Check delegatability**: Determine if item can be delegated
- **Convert to project**: When something needs multiple actions
- **Refine next action**: Reusable when rejecting suggestions, changing context, moving to someday/maybe, deleting, etc.

### Workflow Skills (compose primitives)

- **Process Inbox**: Walk through all inboxes (interview-based). For each item: clarify, provide feedback on actionability, suggest delegatability, suggest context tags.
- **Weekly Review**: Follow exact GTD book process, in order. (Full checklist TBD)
- **Daily Review**: Scan calendar and next actions for a single day.
- **"What should I do now?"**: Interview for context/time/energy if not provided, make recommendation. If rejected, use "Refine next action" skill.
- **Projectize**: Turn a nebulous item into a full project. Output: Todoist project with clear outcome/definition of done, first next action, supporting material/notes.

## Storage Locations

### Todoist (source of truth for actions)

- **Inbox**: Unprocessed captures
- **Next Actions**: Tasks within projects, tagged with contexts
- **Projects**: Use Todoist's hierarchy feature; next actions are tasks within
- **Waiting For**: P4 next action (e.g., "Waiting: John to send report")
- **Priority system**: P4 = waiting/blocked, P3 = workable, P1/P2 unused
- **Contexts**: Tags in Todoist (already exist, will discover)

### Fastmail Calendar (via khal + vdirsyncer)

- Full CRUD for calendar events
- Used for time-specific commitments and time-blocking

### Apple Notes

- **Reference**: Title + raw text only. No folders/tags.
- **Someday/Maybe**: Individual notes per item, must contain `#somedaymaybe` in text.

### Reminders.app

- Functions as **tickler file**, not an inbox.

### Inboxes (4 total)

1. **Todoist inbox** — via `gtd-action`
2. **Email** — via `gtd-email` (Fastmail)
3. **Physical inbox** — agent prompts user to check
4. **~/Documents/Inbox** — filesystem, agent uses built-in tools

## Decisions

- Tool naming: `gtd-*`
- Source of truth: Todoist only; no local mirrors (temp files allowed for parsing, etc)
- Tool output: Plain-text, freeform, human-readable. Exit status communicates what happened.
- Tools are atomic; no workflow-shaped commands.
- No local persistence beyond temporary parsing artifacts.

## Open Questions

- Weekly Review exact checklist/order from the GTD book
- Email tool implementation (what CLI/library for Fastmail IMAP?)
- Full list of contexts (will discover from Todoist)
