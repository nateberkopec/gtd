---
name: weekly-review
description: Guide user through the complete GTD weekly review in three phases - Get Clear, Get Current, Get Creative. Use when user wants to do their weekly review. This is the most critical GTD maintenance ritual.
---

# Weekly Review

The weekly review is the "glue that holds GTD together." This skill guides the user through all three phases of the review process.

## When to Use

- User says "weekly review" or "let's do my weekly review"
- Scheduled weekly review time
- System feels stale or untrustworthy
- User feels overwhelmed or out of control

## Overview

The weekly review has three phases:
1. **Get Clear** (15-25 min) - Empty your head, process inboxes
2. **Get Current** (25-45 min) - Update all lists to reflect reality
3. **Get Creative** (15-30 min) - Strategic thinking, someday/maybe review

Ask:
> "Ready to do your weekly review? This typically takes 60-90 minutes. We'll go through three phases: Get Clear, Get Current, and Get Creative."

## Phase 1: Get Clear

Goal: Empty your head and process all accumulated inputs.

### 1.1 Collect Loose Materials

> "First, let's gather any loose materials. Do you have any papers, sticky notes, business cards, or other physical items that need capturing?"

If yes, help them capture each item to the inbox.

### 1.2 Mind Sweep

Run the mind sweep BEFORE processing inboxes (it captures items into inboxes).

Tell the user:
> "Run this in a separate terminal to trigger your mind sweep:"
> `/Users/nateberkopec/Documents/Code.nosync/personal/gtd/tools/gtd-mindsweep/gtd-mindsweep`

The script displays triggers one at a time (every 0.5 seconds). User should capture anything that comes to mind via Whisper, notes, or typing into Todoist inbox.

When done:
> "Mind sweep complete? Tell me what you captured, or say 'done' if you captured everything directly."

### 1.3 Process Digital Inboxes

Use the `process-inbox` skill to empty:
- Todoist inbox
- Email inbox
- ~/Documents/Inbox

```
gtd-action inbox
gtd-email list
ls ~/Documents/Inbox
```

> "Let's process your digital inboxes to zero."

### 1.4 Review Recent Notes

> "Look through any notes you've taken this week. Anything that needs capturing or acting on?"

**Phase 1 Complete:**
> "Phase 1 complete! Your head is empty and inboxes are at zero. Ready for Phase 2?"

## Phase 2: Get Current

Goal: Ensure your system accurately reflects reality.

### 2.1 Review Next Actions Lists

```
gtd-action list
```

> "Let's scan your next actions. For each one, is it still relevant? Have you done any of these?"

In this stage, we only want to review next actions in the Other Next Action list in Todoist.

For each item, use the clarify-item skill.

### 2.2 Review Projects

```
gtd-action projects
```

> "Let's review your projects. For each one: Is it still active? Does it have a next action?"

This is where we go through each other list in Todoist with items in it, one by one.

We do _not_ review any projects inside Speedshop, only in the Life category.

For each project:
- **Active with next action:** Good, move on
- **Active without next action:** Define next action now
- **Completed:** Celebrate and archive
- **Stalled:** Either define next action or move to someday/maybe
- **No longer relevant:** Archive or delete

Then, run clarify-item on all items in the project.

### 2.3 Review Waiting For

```
gtd-action waiting
```

> "Let's check what you're waiting for from others."

Clarify-item with each.

### 2.4 Review Past Calendar

```
gtd-calendar list 7  # past week
```

Apply the calendar meanings from the `calendar-management` skill.

> "Let's look at the past two weeks. Did any meetings or events create action items that weren't captured?"

Look for:
- Meeting follow-ups
- Commitments made
- Reference material to file

### 2.5 Review Upcoming Calendar

```
gtd-calendar list 7  # next 7 days
```

> "Let's look ahead. What's coming up that needs preparation?"

For each upcoming event:
- Does it need prep work? Create actions
- Are there conflicts to resolve?
- Anything to delegate or reschedule?

### 2.6 Review Checklists

> "Do you have any recurring checklists to review? (Monthly tasks, role responsibilities, etc.)"

**Phase 2 Complete:**
> "Phase 2 complete! Your system is current. Ready for Phase 3?"

## Phase 3: Get Creative

Goal: Strategic thinking and possibility review.

### 3.1 Review Someday/Maybe

```
gtd-notes someday
```

> "Let's look at your Someday/Maybe list. Any of these ready to become active projects?"

For each item:
- **Activate:** Create project, define next action
- **Keep:** Still interesting, leave it
- **Delete:** No longer appeals, remove it

### 3.2 New Ideas and Possibilities

> "Based on this review, any new ideas or projects emerging? Anything you want to start?"

Capture new projects or someday/maybe items.

### 3.3 Review Roles and Balance

> "Think about your various life roles (work, family, personal, health). Is any area being neglected?"

If imbalance detected, consider:
- New projects to address gaps
- Delegating in overloaded areas
- Saying no to new commitments

### 3.4 Goals Check

> "How do your current projects align with your bigger goals? Anything missing?"

**Phase 3 Complete:**
> "Weekly review complete! Your system is clear, current, and you've had space to think strategically."

## Review Stats

At the end, summarize:
- Items processed: [N]
- Actions completed: [N]
- New actions created: [N]
- Projects reviewed: [N]
- Waiting-for items checked: [N]

## Tools Used

- `gtd-action inbox/list/waiting/projects` - Todoist operations
- `gtd-email list` - Email inbox
- `gtd-calendar list` - Calendar review
- `gtd-notes someday` - Someday/maybe items
- `process-inbox` skill - For Phase 1
- `clarify-item` skill - For new captures
- `assign-context` skill - For new actions
