---
name: filesystem-reference
description: File reference material into the filesystem (default ~/Documents/Reference). Use when routing non-actionable items to reference, cleaning up a filesystem inbox, or migrating reference material from another sync service.
---

# Filesystem Reference

This skill files non-actionable reference material into a trusted filesystem reference library. It is separate from the filesystem inbox (`~/Documents/Inbox`) and keeps reference easy to retrieve later.

## When to Use

- User wants to file reference documents or download cleanup
- During inbox processing when an item is “reference”
- During weekly review (“reference material to file”)
- Migration/cleanup of filesystem reference (e.g., Dropbox → new sync)

## Default Roots

- **Reference root (default):** `~/Documents/Reference`
- **Inbox (not reference):** `~/Documents/Inbox`

If the user specifies a different root, use it. Otherwise, default to the reference root above.

## Core Principles

- **Reference is non-actionable.** If an item needs action, create a task/project first, then file the reference.
- **Keep filing lightweight.** Prefer existing folders, shallow hierarchies, and consistent naming.
- **Don’t delete silently.** Ask before deleting and use `trash` instead of `rm`.
- **Inbox is temporary.** Empty `~/Documents/Inbox` during processing; don’t store reference there.

## Workflow

### 1) Confirm Roots and Scope

Ask:
> “We’ll file reference into `~/Documents/Reference`. Any other root or subfolder you want to use?”

If migrating:
> “Where should we pull legacy reference from (Dropbox path)?”

### 2) Gather Items to File

Sources can include:
- Files explicitly provided by the user
- `~/Documents/Inbox`
- Legacy reference roots (Dropbox, old sync)

### 3) Decide the Destination

For each item, determine one of:

- **Reference** → file under `~/Documents/Reference/...`
- **Read/Review** → place in `~/Documents/Reference/Read Review` (ask if they want this folder)
- **Archive** → move to `~/Documents/Reference/Archive/YYYY`
- **Actionable** → create task/project first, then file supporting material

Use existing folders when possible. If no obvious match, propose a folder name and confirm with the user.

### 4) File the Item

- Move the file into the chosen folder
- Preserve filenames unless the user requests cleanup
- For batches, summarize moves before executing

### 5) Report

Summarize what moved where and call out any remaining backlog.

## Migration Mode (Dropbox → New Sync)

When the user is migrating reference material:

1. **Inventory the legacy root** (e.g., `~/Library/CloudStorage/Dropbox/Documents/Reference`)
2. **Map top-level folders** to the new reference root (reuse names when possible)
3. **Create a staging folder** (optional): `~/Documents/Reference/_Staging`
4. **Move in batches** with confirmation before large moves
5. **Defer deep cleanup** unless explicitly requested

## Prompts to Use

- “Is this strictly reference, or do we need a task first?”
- “Where would you look for this later?”
- “Should this go into Read/Review or straight reference?”
- “Do you want to keep this folder structure or simplify it?”

## Example Session

**User:** “File these three PDFs and a screenshot.”

**Agent:** “We’ll file reference into `~/Documents/Reference`. Any preferred folder?”

**User:** “Put health docs together.”

**Agent:** “Got it. I’ll move the PDFs into `~/Documents/Reference/Health` and the screenshot into `~/Documents/Reference/Health` unless you want a different folder. Sound good?”

## Tools Used

- Direct filesystem access (list, read, move, delete via `trash`)
- `gtd-action add` (if an item becomes actionable)
- `gtd-notes add` (if a non-file reference note is needed)
