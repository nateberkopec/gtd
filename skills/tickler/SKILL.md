---
name: tickler
description: Manage the GTD tickler file via the Tickler calendar (all-day events that trigger Todoist inbox items).
---

# Tickler

The GTD tickler file is implemented as an all-day calendar called `Tickler`. An IFTTT integration creates a Todoist inbox item on the day of each tickler event.

## When to Use

- User asks to “tickle” or remind themselves on a specific future date.
- User wants a reminder that should appear in Todoist inbox on a given day.
- User asks how the tickler file works.

## Rules

1. Only use the `Tickler` calendar.
2. All events must be all-day (no start/end times).
3. Event titles should read like actionable todo items.
4. Do not use Reminders.app for tickler unless the user explicitly asks.

## How to Create a Tickler Item

1. Confirm the target date.
2. Create an all-day event in `Tickler` with an actionable title.

Example:
- Date: `2026-02-05`
- Title: `Check passport renewal status`

## How to Review Ticklers

- Use `gtd-calendar list N` to scan upcoming all-day `Tickler` events.
- On the day of the event, expect a new Todoist inbox item to appear.

## Daily Review Check

- Use `gtd-action inbox` to see tickler-generated items for today.
- If a tickler item is present, process it like any other inbox item.

## Tools Used

- `gtd-calendar new` - Create all-day Tickler events
- `gtd-calendar list` - Review upcoming Tickler entries
- `gtd-action inbox` - See Tickler-generated inbox items
