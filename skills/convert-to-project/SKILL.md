---
name: convert-to-project
description: Convert a multi-step item into a proper GTD project with clear outcome and first next action. Use when an item requires more than one action to complete. Creates Todoist project, defines done, identifies first action.
---

# Convert to Project

This skill transforms a nebulous multi-step item into a properly defined GTD project. A project in GTD is any outcome requiring more than one action step.

## When to Use

- Item identified as needing multiple actions (from clarify-item skill)
- User says "this is a big thing" or "there's a lot to do"
- When breaking down complex goals
- Via the `projectize` workflow skill

## Step 1: Define the Outcome

The most important part of a project is knowing what "done" looks like.

Ask:
> "What does successful completion look like? Describe the end state."

Get a concrete, verifiable outcome:

**Too vague:**
- "Handle the website"
- "Deal with the move"
- "Work on health"

**Clear outcomes:**
- "New company website is live with all content migrated"
- "Living in new apartment with all belongings unpacked"
- "Running 5K three times per week"

The outcome should be:
- **Specific**: Clear what it means
- **Verifiable**: You'll know when it's done
- **Achievable**: Within your influence

## Step 2: Create the Project

Create a project in Todoist with the outcome as its description:

```
gtd-action add "[Project Name]" --project-create
```

Or describe the project creation for the user to do in Todoist's UI, as the CLI may not support full project creation.

Project naming conventions:
- Start with a verb or outcome phrase
- Keep it concise but descriptive
- Example: "Launch new marketing website"

## Step 3: Identify the First Next Action

Every project must have at least one next action. Ask:

> "What's the very first physical action needed to move this forward?"

The first action should be:
- Concrete and physical
- Something you can do right now (or in the appropriate context)
- The actual first step, not a planning step

**Common first actions:**
- "Call [person] to discuss..."
- "Draft outline for..."
- "Research options for..."
- "Email [person] asking about..."
- "Schedule meeting to..."

## Step 4: Brainstorm Additional Actions (Optional)

> "What other actions come to mind for this project? Don't worry about order yet."

Capture any obvious next steps. These become tasks within the project.

Note: You don't need to identify ALL actions upfront. GTD encourages identifying the next action and discovering subsequent actions as you go.

## Step 5: Add Actions to Project

Add the first next action (and any others) to the project:

```
gtd-action add "First action description" --project "[Project Name]"
```

Apply appropriate context labels:
```
gtd-action add "First action description" --project "[Project Name]" --label @context
```

## Step 6: Link Supporting Materials

If there are reference materials, notes, or related information:

> "Are there any documents, notes, or reference materials related to this project?"

Options:
- Create a note in Apple Notes with project reference material
- Link to existing documents
- Add comments to the Todoist project

```
gtd-notes add "Project: [Name] - Reference Materials" --body "..."
```

## Output Format

After converting to project:

```
Project: [Name]
Outcome: [Clear description of done]
First Next Action: [Specific physical action]
Additional Actions: [List if any]
Supporting Materials: [Links/notes if any]
```

## Example Session

**Input:** "Plan summer vacation"

**Agent:** "This sounds like it needs multiple steps, so let's turn it into a project. What does 'done' look like for your summer vacation planning?"

**User:** "Flights and hotel booked for 2 weeks in Portugal, with a rough itinerary"

**Agent:** "Great outcome: 'Summer Portugal trip fully booked with 2-week itinerary'. What's the very first thing you need to do?"

**User:** "I need to check my work calendar to see when I can take time off"

**Agent:** "Perfect. First action: 'Check work calendar for available 2-week windows in summer'. Any other actions that come to mind?"

**User:** "Research flights, look at hotels in Lisbon and Porto, check if passport is valid"

**Agent:** Creating the project:

```
Project: Summer Portugal trip booked
Outcome: Flights and hotel booked for 2 weeks in Portugal with rough itinerary
First Next Action: Check work calendar for available 2-week windows in summer
Additional Actions:
  - Research flight options to Lisbon
  - Look at hotels in Lisbon and Porto
  - Verify passport validity
```

## When It's Actually a Single Action

Sometimes what seems like a project is actually one action. Signs it's just an action:
- Can be done in one sitting
- No waiting or dependencies
- Single context needed

If so, don't create a project - just add it as a next action.

## Tools Used

- `gtd-action add --project` - Add tasks to projects
- `gtd-action projects` - List existing projects
- `gtd-notes add` - Create supporting reference notes
