---
name: clarify-item
description: Interview flow to understand what an inbox item is and determine its actionability. Use when processing inbox items to decide if they're actionable and what the next physical action is. Routes non-actionable items to trash, reference, or someday/maybe.
---

# Clarify Item

This skill implements the GTD "Clarify" phase for a single item. It walks through the decision tree to determine what an item is and where it belongs.

## When to Use

- During inbox processing (manual or via process-inbox skill)
- When a user asks "What should I do with this?"
- When triaging any captured item

## The Decision Tree

### Step 1: Understand the Item

First, ensure you understand what the item is. If the item description is vague, ask:

> "Can you tell me more about '[ITEM]'? What is this about?"

### Step 2: Is It Actionable?

Ask yourself (or confirm with user):

> "Is there a physical action required for this item?"

**If NO (not actionable):**
- **Trash**: No longer needed or relevant → Delete it
- **Reference**: Might be useful later → File in Apple Notes as reference
- **Someday/Maybe**: Interesting but not committed → Add to Apple Notes with `#somedaymaybe`

Routing questions:
- "Is this something you might want to do someday, but not now?"
- "Is this reference information you might need later?"
- "Can this simply be deleted?"

**If YES (actionable):** Continue to Step 3.

### Step 3: What's the Desired Outcome?

> "What does 'done' look like for this? What outcome are you trying to achieve?"

This helps determine if it's a single action or a project.

### Step 4: Single Action or Project?

> "Can this be completed in one physical action, or does it require multiple steps?"

**If multiple steps:** This is a project. Use the `convert-to-project` skill.

**If single action:** Continue to Step 5.

### Step 5: Define the Next Physical Action

The next action must be a concrete, physical activity. Help the user refine it:

> "What's the very next physical action you need to take?"

Bad examples (too vague):
- "Handle the report"
- "Deal with the email"
- "Work on the project"

Good examples (specific and physical):
- "Call John at 555-1234 about the report deadline"
- "Draft reply to Sarah's email asking for clarification on budget"
- "Write first paragraph of project proposal"

### Step 6: Determine Time Sensitivity

> "Does this need to happen at a specific time or by a specific date?"

- **Specific time:** Add to calendar (`gtd-calendar add`)
- **Deadline:** Add due date to task (`gtd-action add --due DATE --label @context`)
- **No time constraint:** Add as next action (`gtd-action add --label @context`)

#### The Two-Minute Rule

During processing, if an action would take less than 2 minutes:
> "This would take less than 2 minutes. Do you want to do it now?"

If yes, do it and mark complete. Don't add to lists.

### Step 7: Assign Context Labels

Before adding the next action, fetch available context labels from Todoist:

```
gtd-action labels
```

Use the assign-context skill to guide the user to select appropriate context(s) for the action. The assign-context skill will fetch available contexts from Todoist labels and help determine which contexts apply.

Add the action with the selected context:

```
gtd-action add "Action description" --label @CONTEXT
```

## Output

After clarifying, the item should be routed to one of:

1. **Trash** - Deleted/ignored
2. **Reference** - Added to Apple Notes (no `#somedaymaybe`)
3. **Someday/Maybe** - Added to Apple Notes with `#somedaymaybe`
4. **Project** - Handed off to `convert-to-project` skill
5. **Calendar** - Time-specific action added via `gtd-calendar`
6. **Next Action** - Task added via `gtd-action add` with context labels

## Example Session

**Input:** "Conference registration"

**Agent:** "Can you tell me more about 'Conference registration'?"

**User:** "I need to register for the React Summit conference"

**Agent:** "Is there a physical action required here?"

**User:** "Yes"

**Agent:** "What's the outcome you're looking for?"

**User:** "To be registered and have my ticket"

**Agent:** "Can this be done in one action?"

**User:** "Yes, I just need to go to the website and fill out the form"

**Agent:** "Great. The next action is: 'Go to reactsummit.com and complete registration form'. Is there a deadline?"

**User:** "Early bird ends Friday"

**Agent:** "I'll add this with a Friday due date. Now let me determine the appropriate context using the assign-context skill..."

```
gtd-action labels
```

**Agent:** "This task requires a computer to access the website. I'll tag it as @computer."

```
gtd-action add "Go to reactsummit.com and complete registration form" --due friday --label @computer
```

## Tools Used

- `gtd-action add` - Add tasks to Todoist
- `gtd-calendar add` - Add calendar events
- `gtd-notes add` - Add reference/someday-maybe notes
