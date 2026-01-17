---
name: what-should-i-do-now
description: Help user decide what to work on next based on GTD's four criteria - context, time available, energy level, and priority. Use when user asks what to do or seems stuck on choosing. Handles rejection via refine-next-action skill.
---

# What Should I Do Now

This skill helps users choose their next action using GTD's four-criteria model. It's the "Engage" phase of GTD - actually doing work from trusted lists.

## When to Use

- User asks "What should I do now?"
- User seems paralyzed by options
- User has time and wants to be productive
- After completing a task (what's next?)

## The Four Criteria Model

GTD suggests choosing actions based on (in order):

1. **Context** - What can you do where you are?
2. **Time Available** - How much time do you have?
3. **Energy Level** - What's your mental/physical state?
4. **Priority** - What matters most?

## Step 1: Determine Context

> "Where are you right now, and what tools/resources do you have available?"

Options:
- At computer with internet
- At home
- At office
- On phone only
- Out running errands
- In a meeting/waiting

Map to context tags:
```
gtd-action labels
```

Then filter:
```
gtd-action list --filter "@context"
```

## Step 2: Determine Time Available

> "How much time do you have before your next commitment?"

Categories:
- **< 15 minutes**: Quick wins only
- **15-30 minutes**: Short tasks
- **30-60 minutes**: Medium tasks
- **1+ hours**: Deep work possible

Filter actions by estimated duration (if tracked) or use judgment.

## Step 3: Assess Energy Level

> "What's your energy level right now?"

Levels:
- **High energy/focus**: Creative work, complex problems, writing
- **Medium energy**: Routine tasks, email, planning
- **Low energy**: Administrative, filing, simple tasks

Match actions to energy:
- High: "Draft proposal" "Design architecture" "Difficult conversation"
- Medium: "Process email" "Review document" "Schedule meetings"
- Low: "File papers" "Update spreadsheet" "Simple responses"

## Step 4: Consider Priority

From the filtered list, consider:
- What has a deadline?
- What's blocking others?
- What would have the biggest impact?
- What have you been avoiding?

## Making the Recommendation

After gathering the four criteria:

> "Based on your context (@office), time (45 minutes), energy (medium), and priorities, here are my top suggestions:
>
> 1. **[Action]** - [Why it fits]
> 2. **[Action]** - [Why it fits]
> 3. **[Action]** - [Why it fits]
>
> What resonates?"

## Handling Rejection

If user rejects all suggestions, use `refine-next-action` skill:

> "None of these work? Let's figure out what would.
>
> Is it the context? Time estimate? Energy required? Or something else?"

Options:
- Show different actions
- Adjust criteria (maybe energy is lower than stated)
- Check if procrastination is involved
- Consider if tasks need refinement

## The Procrastination Check

If user keeps rejecting:

> "You've passed on several options. Sometimes this means:
> - The tasks are too vague (need clearer next actions)
> - Energy is lower than we thought
> - There's resistance to something specific
>
> What's going on?"

Help them either:
- Refine the resisted task
- Choose something energizing to build momentum
- Acknowledge it's not a good time

## Just Do Mode

If user wants less discussion:

> "Here's your top action for right now: [Action]. Go!"

Quick recommendation without lengthy interview.

## Example Session

**User:** "What should I do now?"

**Agent:** "Let me help you pick. Where are you and what do you have available?"

**User:** "At my desk at home, computer"

**Agent:** "How much time until your next thing?"

**User:** "About an hour"

**Agent:** "And how's your energy - ready for focused work, or need something lighter?"

**User:** "Medium, I just had lunch"

**Agent:**
```
gtd-action list --filter "@computer | @home"
```

"Here's what I'd suggest from your @computer and @home lists:

1. **Review Q3 report draft** - Good medium-energy task, ~30 min
2. **Process email inbox** - Medium energy, routine, ~20 min
3. **Call plumber about leak** - Quick @phone task, 10 min

Any of these feel right?"

**User:** "I don't want to do the report right now"

**Agent:** "Understood. Would you rather tackle the email or make that quick call first?"

**User:** "The call, get it out of the way"

**Agent:** "Great choice - quick win to build momentum. After that, maybe email while you're in task mode?"

## Providing the Recommendation

Format:
```
CONTEXT: @home, @computer
TIME: ~1 hour
ENERGY: Medium

TOP RECOMMENDATION:
→ [Action description]
  Why: [Brief rationale]

ALTERNATIVES:
- [Action 2]
- [Action 3]
```

## After Task Completion

When user finishes:
> "Nice work! Ready for the next one, or taking a break?"

Keep momentum going if they want to continue.

## Tools Used

- `gtd-action labels` - Available contexts
- `gtd-action list --filter` - Context-filtered actions
- `refine-next-action` skill - When suggestions rejected
- `gtd-calendar today` - Check time constraints
