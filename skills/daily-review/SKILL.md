---
name: daily-review
description: Quick daily scan of calendar and next actions to stay on top of the day. Use at the start of each day or when user asks what's happening today. Shows time-sensitive items and context-appropriate actions.
---

# Daily Review

A quick daily scan to maintain awareness of commitments and priorities. Unlike the weekly review, this is fast (5-10 minutes) and focused on immediate awareness.

## When to Use

- Start of each day
- User asks "What's on for today?"
- User asks "What should I focus on?"
- Quick orientation after being away

## Daily Review Steps

### Step 1: Today's Calendar

```
gtd-calendar today
```

> "Here's what's on your calendar today:"

Apply the calendar semantics from the `calendar-management` skill.

Present:
- Scheduled meetings/events
- Time blocks
- Deadlines

Flag any:
- Back-to-back meetings
- Prep needed before meetings
- Conflicts to resolve

### Step 2: Due/Overdue Items

```
gtd-action list --filter "today | overdue"
```

> "Items due today or overdue:"

Highlight:
- **Overdue:** Need immediate attention
- **Due today:** Must complete by end of day
- **Time-sensitive:** Has a specific deadline

### Step 3: Waiting-For Check

```
gtd-action waiting
```

> "Quick check on items you're waiting for - any follow-ups needed?"

Flag items that:
- Are overdue
- Need a nudge
- Might affect today's work

### Step 4: Quick Inbox Glance

```
gtd-action inbox
gtd-email list
```

> "Quick inbox check: [N] items in Todoist, [N] emails"

Don't process now - just awareness. If anything urgent, flag it.

### Step 5: Context Preview

Based on likely contexts for the day:

> "You'll probably be at [context] today. Here are relevant actions:"

```
gtd-action list --filter "@office" # or whatever context
```

### Step 6: Energy/Priority Scan

> "Of your available actions, which 1-3 things would make today a success if completed?"

Help identify the "big rocks" for the day.

## Output Format

Present a concise daily summary:

```
📅 TODAY: [Date]

CALENDAR:
- 9:00 AM: Team standup
- 2:00 PM: Client call (prep needed)
- 4:00 PM: Dentist appointment

⚠️ DUE/URGENT:
- Report due today
- Overdue: Call back vendor

⏳ WAITING FOR:
- Sarah: Q4 numbers (expected today)

📥 INBOXES:
- Todoist: 3 items
- Email: 12 unread

🎯 TODAY'S FOCUS:
- Finish report
- Prepare for client call
- Process inbox (if time)
```

## Quick Version

For an ultra-quick check:

```
gtd-calendar today && gtd-action list --filter "today | overdue"
```

> "Calendar: [events]. Due today: [tasks]. Overdue: [tasks]."

## Integration with What Should I Do Now

If user wants guidance on what to do next after daily review:

> "Would you like help deciding what to do first? I can help based on your context, time, and energy."

Hand off to `what-should-i-do-now` skill.

## Example Session

**User:** "What's my day look like?"

**Agent:**
```
gtd-calendar today
gtd-action list --filter "today | overdue"
gtd-action waiting
```

> "Here's your Tuesday:
>
> **Calendar:**
> - 10:00 AM: Sprint planning (1 hour)
> - 1:00 PM: Lunch with Alex
> - 3:00 PM: Design review
>
> **Due Today:**
> - Submit expense report
> - Review PR for feature branch
>
> **Overdue:**
> - Call insurance company (was due Monday)
>
> **Waiting For:**
> - Design team: Final mockups (needed for 3 PM meeting)
>
> **Inboxes:** 2 in Todoist, 8 emails
>
> Heads up: You might want to follow up on those mockups before your 3 PM meeting."

## End of Day Version

For end-of-day review:

> "How did today go? Let's do a quick wrap-up."

1. What got done? Mark items complete
2. What didn't happen? Reschedule or reconsider
3. Anything for tomorrow's calendar?
4. Quick inbox check for tomorrow

## Tools Used

- `gtd-calendar today` - Today's events
- `gtd-action list --filter` - Filtered task lists
- `gtd-action waiting` - Waiting-for items
- `gtd-action inbox` - Inbox count
- `gtd-email list` - Email count
