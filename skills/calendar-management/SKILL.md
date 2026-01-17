---
name: calendar-management
description: Document how to read and edit calendars with specific semantics (Fastmail, Schedule, shared calendars). Use when adding, editing, or summarizing calendar events.
---

# Calendar Management

This skill documents the meaning of each calendar and how to use them. Use it whenever a request involves reading, adding, or modifying calendar events.

## Calendar Map

- `DEFAULT_TASK_CALENDAR_NAME`: Ignore. Backend Fastmail calendar; never read or write.
- `lillianrusing@gmail.com`: Read-only. Use only for awareness of Lillian’s schedule.
- `Calendar`: Primary calendar. Use for meetings, appointments, and most commitments.
- `Schedule`: Timeboxing calendar. Use for planned focus blocks and daily structure. Managed by another tool; only edit if user explicitly requests.
- `Nate (Speedshop)`: Speedshop commitments. Use when user asks to track Speedshop work; confirm if unsure.

## Rules of Use

1. Default to `Calendar` unless user specifies otherwise.
2. Treat `Schedule` as read-only unless the user asks to modify it.
3. Do not modify `lillianrusing@gmail.com` under any circumstances.
4. Use `Nate (Speedshop)` only when user requests or confirms.

## Common Requests

### Add a normal meeting or appointment
- Use `Calendar`.

### Timebox a block (focus or routine)
- Use `Schedule`, but ask for confirmation if it wasn’t explicit.

### Check what’s going on today
- Use `gtd-calendar today` and apply the calendar map above when summarizing.

## Tools Used

- `gtd-calendar today` - Daily calendar view
- `gtd-calendar list` - Multi-day scans
- `gtd-calendar new` - Create events
- `gtd-calendar edit` - Edit/delete events
