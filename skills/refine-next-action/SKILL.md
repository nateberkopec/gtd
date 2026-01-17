---
name: refine-next-action
description: Handle refinement of next actions when user rejects suggestions, wants to change context, defer, delegate, or break down further. Use when a suggested action doesn't fit or circumstances change.
---

# Refine Next Action

This skill handles renegotiation of next actions. Use it when the user rejects a suggested action or when circumstances require changing an existing action.

## When to Use

- User rejects a suggested next action
- User wants to change an action's context
- User wants to move action to someday/maybe
- User wants to delete/drop an action
- Action needs to be broken down further
- User wants to defer an action

## Refinement Options

When a user rejects or wants to change an action, offer these options:

> "What would you like to do with this action?
> 1. Change the wording (make it more specific)
> 2. Change the context (different location/tool)
> 3. Break it down (it's still too big)
> 4. Defer it (not now, but keep it)
> 5. Move to Someday/Maybe (interested but not committed)
> 6. Delegate it (someone else should do it)
> 7. Drop it (no longer relevant)"

## Option 1: Change Wording

The action description needs refinement.

Ask:
> "What's a better way to describe this action? Remember: it should be a concrete, physical action."

Verify it's still:
- Specific and concrete
- A single action (not multiple steps)
- Clear about what "doing it" means

```
gtd-action modify TASK_ID --content "New action description"
```

## Option 2: Change Context

The action needs a different context tag.

```
gtd-action labels
```

Ask:
> "What context would work better? Your options are: [list contexts]"

```
gtd-action modify TASK_ID --label @new-context
```

To remove old context and add new one, may need to use Todoist directly.

## Option 3: Break It Down

The action is still too big or vague.

Ask:
> "This still feels too big. What's a smaller first step?"

Keep asking until you get to a truly atomic action:
- Can be done in one sitting
- No ambiguity about what to do
- Clear starting point

If breaking down reveals multiple steps, use `convert-to-project` skill.

## Option 4: Defer

The action is valid but not for now.

Ask:
> "When should this resurface? Pick a specific date."

Options:
- Add a due date to the task

```
gtd-action modify TASK_ID --due [date]
```

## Option 5: Move to Someday/Maybe

The user is interested but not committed to doing this.

1. Remove from Todoist:
```
gtd-action delete TASK_ID
```

2. Add to Apple Notes with someday/maybe tag:
```
gtd-notes add "[Action description]" --body "Moved from next actions. #somedaymaybe"
```

Tell the user:
> "I've moved this to your Someday/Maybe list. It will be reviewed during your weekly review."

## Option 6: Delegate

Hand off to `check-delegatability` skill:

> "Let's figure out who should do this instead."

Use the check-delegatability skill to:
- Identify who could do it
- Create a waiting-for item
- Set follow-up reminder

## Option 7: Drop It

The action is no longer relevant or needed.

Confirm:
> "Are you sure you want to delete '[action]'? This can't be undone."

```
gtd-action delete TASK_ID
```

Reasons to drop:
- Circumstances changed
- No longer relevant
- Was never important
- Duplicate of another action

## Example Session

**Agent suggests:** "Call dentist to schedule cleaning"

**User:** "I don't want to do that right now"

**Agent:** "What would you like to do with this action?
1. Change the wording
2. Change the context
3. Break it down
4. Defer it
5. Move to Someday/Maybe
6. Delegate it
7. Drop it"

**User:** "Defer it to next month"

**Agent:** "When specifically should this come back?"

**User:** "February 1st"

**Agent:** "I'll set the due date to February 1st."

```
gtd-action modify TASK_ID --due "2025-02-01"
```

## Handling Persistent Rejection

If a user keeps rejecting variations of the same action:

> "You've refined this action several times. Let me ask: Is this actually something you want or need to do? It's okay if the answer is no."

Sometimes the right answer is to drop it entirely.

## Tools Used

- `gtd-action modify` - Change task properties
- `gtd-action delete` - Remove tasks
- `gtd-action labels` - List available contexts
- `gtd-notes add` - Create someday/maybe notes
- `check-delegatability` skill - For delegation
- `convert-to-project` skill - If breaking down reveals a project
