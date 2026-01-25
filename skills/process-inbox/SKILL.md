---
name: process-inbox
description: Walk through all GTD inboxes and process each item to zero. Use for regular inbox processing or when user says "help me process my inbox". Integrates clarify-item, assign-context, and check-delegatability skills.
---

# Process Inbox

This skill implements the GTD inbox processing workflow across all capture points. The goal is to get each inbox to zero by making decisions about every item.

## When to Use

- User asks to process their inbox
- During weekly review (Get Clear phase)
- When inbox count is high
- Regular daily/frequent processing

## The Five Inboxes

1. **Todoist Inbox** - Digital task captures (`gtd-action inbox`)
2. **Email Inbox** - Unprocessed emails (`gtd-email list`)
3. **Reminders Inbox (Due)** - Due/overdue Reminders.app items (`gtd-reminders due`, `gtd-reminders overdue`)
4. **Physical Inbox** - Paper, objects, notes (user prompt)
5. **Filesystem Inbox** - ~/Documents/Inbox (agent reads directly)

## The Processing Loop

For each inbox:

1. **List all items** in the inbox up front
2. **Group related items** internally (same stem/subject/sender)
3. **Process each group/item**: Run the clarify-item skill.

## Processing Each Inbox

### Todoist Inbox

Use the following tool:

```
gtd-action inbox
```

List all items, then group related ones internally (shared prefix or project keyword).

If you have to fall back on something where the tool isn't working, use `todoist` CLI directly, don't use curl.

For each group/item:
1. Present: "Next group: '[GROUP]'" and list included items
2. Run the clarify-item skill against the item.

#### Whisper Items (Todoist)

Whisper items are transcribed voice notes, typically prefixed with `[Whisper]`.
When a group contains Whisper items:

1. Process **one item at a time** (do not summarize the group)
2. Show the **full transcription** for each item:
   - Fetch the task via `$ todoist` to check for comments with attachments
   - If there's an HTML attachment, download it and extract the transcription text from the `<p>` tag
   - The HTML also contains a "Share this memo" link - extract and display this URL so the user can view the original Whisper memo in their browser if needed
3. Present the transcription and the Whisper URL, then proceed with Run the clarify-item skill against the item.

### Email Inbox

```
gtd-email list
```

List all emails, then group related ones internally (same subject/thread or sender).
For each group/email:
1. Present the group label with subjects and senders
2. Read if needed: `gtd-email read ID`
3. Run the clarify-item skill against the item.

```
gtd-email archive ID
# or
gtd-email delete ID
```

### Reminders Inbox (Due)

```
gtd-reminders due --plain
gtd-reminders overdue --plain
```

List all reminders that are due today or overdue, then group related ones internally.
In `--plain` output, the first column is the reminder ID to use for `complete/edit/delete`.
For each reminder/group:
1. Present the reminder text and ID
2. Run the clarify-item skill against the item
3. Route the outcome by either completing/editing the reminder or creating the appropriate task/calendar entry

Common actions:

```
gtd-reminders complete ID
# or
gtd-reminders edit ID ...
# or
gtd-reminders delete ID
```

### Physical Inbox

Prompt the user:
> "Do you have anything in your physical inbox? Papers, notes, objects that need processing?"

If yes:
> "Please list all physical items so I can group related ones."

Then group internally and apply the clarify-item skill against the item.

### Filesystem Inbox

```
ls ~/Documents/Inbox
```

List all files, then group related ones internally (shared filename stem/prefix).

**For image files:** Use `open` to display the image to the user before processing, so they can see what it contains.

Run the clarify-item skill against the item.

## Processing Order

Recommended order:
1. **Filesystem inbox** - Quick to scan
2. **Physical inbox** - Gets it out of the way
3. **Email inbox** - Often the largest
4. **Reminders inbox (due/overdue)** - Time-triggered items that surfaced today
5. **Todoist inbox** - Core task capture

## Progress Tracking

Keep user informed:
- "Todoist inbox: 5 items remaining"
- "Email inbox: 12 items remaining"
- "Reminders inbox (due): 3 items remaining"
- "Processed 8 items so far"

## Completion

When all inboxes are at zero:
> "All inboxes are at zero! You've processed [N] items total."

Celebrate the clear inbox feeling.

## Final Check

Before finishing the session, check for any new items that may have arrived during processing:

1. Sync Todoist:
```fish
todoist sync
gtd-action inbox
```

2. Refresh email list:
```fish
gtd-email list
```

3. Check reminders again:
```fish
gtd-reminders due --plain
gtd-reminders overdue --plain
```

4. Check filesystem inbox again:
```fish
ls ~/Documents/Inbox
```

If any new items appeared, process them. When truly empty:
> "All inboxes confirmed at zero with final check. Done!"

## Skills Used

- `clarify-item` - For each item

## Tools Used

- `gtd-action inbox` - List Todoist inbox
- `gtd-action add/complete/delete` - Manage tasks
- `gtd-email list/read/archive/delete` - Process email
- `gtd-reminders due/overdue/complete/edit/delete` - Process Reminders.app due items
- `gtd-notes add` - Save reference/someday-maybe
- Direct filesystem access for ~/Documents/Inbox
