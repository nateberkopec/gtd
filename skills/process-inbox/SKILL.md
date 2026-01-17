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

## The Four Inboxes

1. **Todoist Inbox** - Digital task captures (`gtd-action inbox`)
2. **Email Inbox** - Unprocessed emails (`gtd-email list`)
3. **Physical Inbox** - Paper, objects, notes (user prompt)
4. **Filesystem Inbox** - ~/Documents/Inbox (agent reads directly)

## Processing Modes

### Mode 1: Process All (Default)

Walk through every inbox, every item. This is the default unless the user explicitly asks otherwise.

### Mode 2: Process One Item (Only if user asks)

Process just the next item from any inbox when the user explicitly requests a single item.

## The Processing Loop

For each inbox:

1. **List all items** in the inbox up front
2. **Group related items** internally (same stem/subject/sender)
3. **Process each group/item**:
   - Present the group label and included items
   - Apply clarify-item skill to determine what it is
   - If actionable: apply assign-context and check-delegatability
   - Route to appropriate destination
   - Remove from inbox (mark done, delete, archive)

## Processing Each Inbox

### Todoist Inbox

```
gtd-action inbox
```

List all items, then group related ones internally (shared prefix or project keyword).
For each group/item:
1. Present: "Next group: '[GROUP]'" and list included items
2. Clarify: Use clarify-item skill
3. If it stays as a task, assign context and check delegatability
4. Move to appropriate project or mark complete

#### Whisper Items (Todoist)

Whisper items are transcribed voice notes, typically prefixed with `[Whisper]`.
When a group contains Whisper items:

1. Process **one item at a time** (do not summarize the group)
2. Show the **full transcription** for each item
   - If the transcription isn’t fully visible in the task title, open the task details and expand the notes/description
   - If it’s only available via a link, open the link and display the full transcription text
3. Ask: “Would you like me to play the original voice file?”
4. If yes, locate the audio URL (often in the task details or linked page) and play it via CLI
   - On macOS: `afplay <audio-file-or-url>` (download to `/tmp` if needed)

### Email Inbox

```
gtd-email list
```

List all emails, then group related ones internally (same subject/thread or sender).
For each group/email:
1. Present the group label with subjects and senders
2. Read if needed: `gtd-email read ID`
3. Decide:
   - **Actionable:** Create task, then archive email
   - **Reference:** Save info to notes, archive email
   - **Trash:** Delete email
   - **Respond now:** If < 2 minutes, do it

```
gtd-email archive ID
# or
gtd-email delete ID
```

### Physical Inbox

Prompt the user:
> "Do you have anything in your physical inbox? Papers, notes, objects that need processing?"

If yes:
> "Please list all physical items so I can group related ones."

Then group internally and apply clarify-item to each group/item.

### Filesystem Inbox

```
ls ~/Documents/Inbox
```

List all files, then group related ones internally (shared filename stem/prefix).
For each group/file:
1. Read or describe the group/items
2. Decide what to do with it
3. Move to appropriate location or delete

## Processing Order

Recommended order:
1. **Filesystem inbox** - Quick to scan
2. **Physical inbox** - Gets it out of the way
3. **Todoist inbox** - Core task capture
4. **Email inbox** - Often the largest

Or let user choose:
> "Which inbox would you like to start with?"

## The Two-Minute Rule

During processing, if an action would take less than 2 minutes:
> "This would take less than 2 minutes. Do you want to do it now?"

If yes, do it and mark complete. Don't add to lists.

## Progress Tracking

Keep user informed:
- "Todoist inbox: 5 items remaining"
- "Email inbox: 12 items remaining"
- "Processed 8 items so far"

## Completion

When all inboxes are at zero:
> "All inboxes are at zero! You've processed [N] items total."

Celebrate the clear inbox feeling.

## Example Session

**User:** "Help me process my inbox"

**Agent:** "Let's get your inboxes to zero. You have:
- Todoist inbox: 3 items
- Email inbox: 7 items
- Filesystem inbox: 2 files
- Physical inbox: (unknown)

Starting with Todoist inbox. Items: 'Call about insurance', 'Insurance claim number', 'Pay rent'. Grouped the first two together."

*[Agent applies clarify-item skill]*

**Agent:** "Is there a physical action needed for the insurance group?"

**User:** "Yes, I need to call them about my claim"

**Agent:** "What's the specific next action?"

**User:** "Call State Farm at 555-1234 about claim #12345"

**Agent:** "I'll add that as a next action. What context? I see you have @phone, @computer, @home, @office, @errands"

**User:** "@phone"

**Agent:** "Could someone else make this call?"

**User:** "No, it's my policy"

**Agent:**
```
gtd-action add "Call State Farm at 555-1234 about claim #12345" --label @phone
gtd-action complete [original item]
```

"Done. 2 items remaining in Todoist inbox. Next group: '[group]'..."

## Skills Used

- `clarify-item` - For each item
- `assign-context` - For actionable items
- `check-delegatability` - For actionable items
- `convert-to-project` - When item needs multiple actions
- `refine-next-action` - When user rejects suggestions

## Tools Used

- `gtd-action inbox` - List Todoist inbox
- `gtd-action add/complete/delete` - Manage tasks
- `gtd-email list/read/archive/delete` - Process email
- `gtd-notes add` - Save reference/someday-maybe
- Direct filesystem access for ~/Documents/Inbox
