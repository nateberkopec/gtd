---
name: assign-context
description: Suggest and assign context tags to actions based on where/how they can be done. Use after clarifying an item to determine what contexts (location, tool, energy level) are needed. Fetches available contexts from Todoist labels.
---

# Assign Context

This skill helps assign appropriate context tags to next actions. Contexts in GTD indicate where or with what tools an action can be performed.

## When to Use

- After clarifying an item as a next action
- When organizing tasks by context
- When a user asks "Where should I do this?" or "What context does this need?"

## Step 1: Fetch Available Contexts

First, get the list of available context labels from Todoist:

```
gtd-action labels
```

Common GTD contexts include:
- `@computer` - Needs a computer
- `@phone` - Phone calls to make
- `@home` - Can only be done at home
- `@office` - Can only be done at office/work
- `@errands` - Out and about, running errands
- `@waiting` - Waiting for someone else
- `@anywhere` - Can be done anywhere
- `@email` - Email-related tasks
- `@read` - Reading to do
- `@agenda` - Items to discuss with specific people

## Step 2: Analyze the Action

Consider what the action requires:

1. **Location**: Where must this be done?
   - At home? At office? Anywhere?

2. **Tools/Resources**: What's needed?
   - Computer? Phone? Internet? Specific software?

3. **People**: Does it involve specific people?
   - Meeting? Call? Discussion?

4. **Energy Level**: What mental state is needed?
   - High focus? Low energy OK?

## Step 3: Suggest Context(s)

Based on analysis, suggest the most appropriate context:

> "This action seems like it needs [CONTEXT] because [REASON]. Does that sound right?"

### Multiple Contexts

Some actions may have multiple valid contexts. For example:
- "Review document" could be `@computer` or `@read`
- "Call mom" could be `@phone` or `@home`

Ask:
> "This could be done in multiple contexts. Which of these apply: [contexts]?"

### No Context / Anywhere

If an action can truly be done anywhere:
> "This seems like it can be done anywhere. Should I tag it as `@anywhere` or leave it without a context?"

## Step 4: Apply Context

Add the context label to the task:

```
gtd-action modify TASK_ID --label @context
```

Or when creating a new task:

```
gtd-action add "Task description" --label @context
```

## Context Selection Guide

| Action Type | Suggested Context |
|-------------|-------------------|
| Make a phone call | `@phone` |
| Send an email | `@email` or `@computer` |
| Write/edit document | `@computer` |
| Buy something | `@errands` |
| Fix something at home | `@home` |
| Talk to colleague | `@office` or `@agenda:[name]` |
| Read article/book | `@read` |
| Research online | `@computer` |
| Waiting for response | `@waiting` |

## Example Session

**Input:** Task "Draft proposal for new client"

**Agent:** "Let me check what contexts are available..."

```
gtd-action labels
```

**Agent:** "I see you have: @computer, @phone, @home, @office, @errands, @read

This task 'Draft proposal for new client' needs a computer to write the document. I'd suggest `@computer`. Does that work, or would you prefer a different context?"

**User:** "Actually I can only do this at the office because I need access to our templates"

**Agent:** "Got it, I'll assign `@office` instead."

```
gtd-action modify TASK_ID --label @office
```

## Handling New Contexts

If the user needs a context that doesn't exist:

> "You don't have a context for that yet. Would you like me to create a new label called `@[name]`?"

## Tools Used

- `gtd-action labels` - List available context labels
- `gtd-action modify --label` - Add label to existing task
- `gtd-action add --label` - Create task with label
