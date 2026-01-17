---
name: projectize
description: Turn a nebulous or complex item into a fully-formed GTD project with clear outcome, first next action, and supporting materials. Use when something needs to be broken down into a project with multiple actions.
---

# Projectize

This skill transforms vague, complex, or overwhelming items into well-defined GTD projects. It's a complete workflow that combines interviewing for clarity with project creation.

## When to Use

- User has a "big thing" they're not sure how to tackle
- Something feels overwhelming or unclear
- Item identified as needing multiple actions (from clarify-item)
- User says "I need to figure out how to do [X]"
- During natural planning for complex outcomes

## The Projectize Workflow

### Step 1: Capture the Raw Item

> "What's the thing you need to turn into a project?"

Get the initial, possibly vague description.

### Step 2: Define the Outcome

This is the most important step. Ask:

> "Imagine this is complete and successful. What does that look like? Describe the end state."

Keep probing until the outcome is:
- **Specific**: Clear what it means
- **Measurable**: You'll know when it's done
- **Achievable**: Within their influence

Examples of transformation:
- "Handle the move" → "Living in new apartment with all belongings unpacked and old apartment cleaned"
- "Get healthy" → "Running 3x per week and meal prepping every Sunday"
- "Fix the website" → "Website loads in under 2 seconds with all broken links fixed"

### Step 3: Why Does This Matter?

> "Why is this important to you? What does completing this enable?"

Understanding purpose helps with:
- Motivation during execution
- Prioritization decisions
- Knowing when to push vs. let go

### Step 4: Envision Success (Wild Success)

> "If this went even better than expected, what would that look like?"

Optional but powerful for creative projects. Expands thinking.

### Step 5: Brainstorm Components

> "What are all the things that might need to happen? Don't worry about order - just dump ideas."

Capture everything:
- Actions
- Decisions to make
- Information to gather
- People to involve
- Resources needed

### Step 6: Organize and Sequence

> "Looking at this list, what naturally comes first? What depends on what?"

Group into:
- **Immediate actions** - Can start now
- **Sequential dependencies** - Must happen in order
- **Parallel tracks** - Can happen simultaneously
- **Final steps** - Wrapping up

### Step 7: Identify the First Next Action

> "What's the very first physical action to get this moving?"

Must be:
- Concrete and specific
- Doable right now (or in appropriate context)
- Actually the first thing (not step 3 or 4)

Common first actions:
- "Call/email [person] to discuss..."
- "Research [topic] to understand options"
- "Draft outline for..."
- "Schedule meeting to kick off..."
- "Buy/gather [supplies]"

### Step 8: Create the Project

Create in Todoist:
```
gtd-action add "[Project Name]" --project-create
```

Add the outcome as project description/note.

### Step 9: Add Actions to Project

Add the first next action:
```
gtd-action add "[First action]" --project "[Project Name]" --label @context
```

Add other identified actions (but don't over-plan):
```
gtd-action add "[Action 2]" --project "[Project Name]"
```

### Step 10: Create Supporting Materials

If reference material is needed:
```
gtd-notes add "Project: [Name] - Reference" --body "[relevant info]"
```

Link to existing documents, create checklists, etc.

## Output Summary

Present the completed project:

```
PROJECT: [Name]

OUTCOME:
[Clear description of done]

WHY IT MATTERS:
[Purpose/motivation]

FIRST NEXT ACTION:
→ [Specific action] (@context)

ADDITIONAL ACTIONS:
- [Action 2]
- [Action 3]
- [Action 4]

SUPPORTING MATERIALS:
- [Note/doc if created]
```

## Example Session

**User:** "I need to renovate my home office"

**Agent:** "Let's turn this into a clear project. When this renovation is complete and successful, what does your office look like?"

**User:** "A dedicated space with a standing desk, good lighting, and no distractions"

**Agent:** "Great - 'Home office renovated with standing desk, proper lighting, and distraction-free setup.' Why is this important?"

**User:** "I work from home and my current setup kills my back and makes it hard to focus"

**Agent:** "Got it - better health and focus. What are all the things that might need to happen?"

**User:** "Get a standing desk, figure out lighting, maybe paint, organize cables, get a better chair too, soundproof somehow..."

**Agent:** "Good brainstorm. What needs to happen first?"

**User:** "I guess I need to measure the space and figure out budget"

**Agent:** "Perfect first step. Let me create this project:

```
PROJECT: Home office renovated

OUTCOME:
Dedicated workspace with standing desk, proper lighting, and distraction-free setup

WHY IT MATTERS:
Better health (back pain) and improved focus for WFH

FIRST NEXT ACTION:
→ Measure office dimensions and sketch layout options (@home)

ADDITIONAL ACTIONS:
- Research standing desk options and prices
- Get lighting recommendations (ask in r/homeoffice?)
- Decide on paint color
- Research soundproofing options
- Budget calculation

SUPPORTING MATERIALS:
- Create note for collecting desk/lighting research
```

Ready for me to create this in your system?"

## When to Stop Planning

Don't over-plan. Once you have:
- Clear outcome
- First next action
- General sense of scope

Stop. Let the next actions emerge as you execute.

> "We have enough to get started. The next steps will become clearer as you make progress."

## Tools Used

- `gtd-action add --project` - Create tasks in projects
- `gtd-action projects` - Check existing projects
- `gtd-notes add` - Create reference materials
- `assign-context` skill - For context assignment
- `convert-to-project` skill - Lower-level project creation
