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

For each inbox, for each item:

1. **Present the item** to the user
2. **Apply clarify-item skill** to determine what it is
3. **If actionable:** Apply assign-context and check-delegatability
4. **Route** to appropriate destination
5. **Remove from inbox** (mark done, delete, archive)
6. **Move to next item**

## Processing Each Inbox

### Todoist Inbox

```
gtd-action inbox
```

For each item:
1. Present: "Next item: '[TITLE]'"
2. Clarify: Use clarify-item skill
3. If it stays as a task, assign context and check delegatability
4. Move to appropriate project or mark complete

### Email Inbox

```
gtd-email list
```

For each email:
1. Present subject and sender
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
> "Pick up the first item. What is it?"

Then apply clarify-item skill.

### Filesystem Inbox

```
ls ~/Documents/Inbox
```

For each file:
1. Read or describe the file
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

Starting with Todoist inbox. First item: 'Call about insurance'"

*[Agent applies clarify-item skill]*

**Agent:** "Is there a physical action needed for 'Call about insurance'?"

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

"Done. 2 items remaining in Todoist inbox. Next item: '[item]'..."

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
