---
name: check-delegatability
description: Determine if an action can and should be delegated to someone else. Use when processing actions to identify delegation opportunities. Outputs whether item is delegatable, suggested delegate, and waiting-for format.
---

# Check Delegatability

This skill helps determine whether an action should be delegated and, if so, to whom. Delegation is a key GTD concept for managing workload effectively.

## When to Use

- When clarifying a next action
- During inbox processing
- When reviewing workload
- When an action isn't the best use of your time

## Step 1: Can Someone Else Do This?

Ask:

> "Is there someone else who could do this task?"

Consider:
- Team members with relevant skills
- Assistants or support staff
- Family members (for personal tasks)
- External services or contractors
- Automated tools or systems

**If no one else can do it:** Not delegatable. Exit this skill.

**If someone else could:** Continue.

## Step 2: Should It Be Delegated?

Consider these factors:

### Reasons to Delegate

1. **Expertise**: Someone else has better skills for this
2. **Efficiency**: It's not the best use of your time
3. **Development**: It's a growth opportunity for someone
4. **Capacity**: You're overloaded and they have bandwidth
5. **Appropriateness**: It's part of their role/responsibility

### Reasons NOT to Delegate

1. **Accountability**: You must personally own the outcome
2. **Confidentiality**: Sensitive information involved
3. **Relationship**: Personal touch is important
4. **Speed**: Delegation overhead exceeds doing it yourself
5. **Learning**: You need to develop this skill yourself

Ask:
> "Should this be delegated? Consider: Who has the expertise? Is this the best use of your time? Is there a development opportunity here?"

## Step 3: Identify the Delegate

> "Who specifically should do this?"

Get a specific name or role:
- "Sarah on the marketing team"
- "My assistant"
- "The IT helpdesk"
- "A contractor"

## Step 4: Determine Delegation Method

How will you delegate?

1. **Direct ask**: Email, message, or conversation
2. **Formal request**: Ticket, task assignment
3. **Standing delegation**: Part of their ongoing responsibilities

## Step 5: Create Waiting-For Entry

Once delegated, create a waiting-for item to track it:

Format: `Waiting: [Person] to [action]`

Examples:
- "Waiting: Sarah to send Q4 report"
- "Waiting: IT to fix printer on 3rd floor"
- "Waiting: John to review contract draft"

Use priority P4 for waiting items:

```
gtd-action add "Waiting: [Person] to [action]" --priority 4
```

## Step 6: Set Follow-Up Date (Optional)

> "When should you follow up if you haven't heard back?"

If there's a deadline or expected completion date:

```
gtd-action add "Waiting: [Person] to [action]" --priority 4 --due [date]
```


## Output Format

After checking delegatability, output:

```
Delegatable: Yes/No
Delegate: [Name/Role] (if yes)
Waiting-for: "Waiting: [Person] to [action]" (if delegated)
Follow-up date: [Date] (if applicable)
```

## Example Session

**Input:** "Prepare monthly expense report"

**Agent:** "Is there someone else who could prepare this report?"

**User:** "Yes, my assistant Maria usually helps with these"

**Agent:** "Should this be delegated to Maria? She has the skills and it's part of her role."

**User:** "Yes, definitely"

**Agent:** "When do you need it completed?"

**User:** "By end of week"

**Agent:** "I'll create the delegation. What's the specific ask for Maria?"

**User:** "Pull expense data from the system and format it in the standard template"

**Agent:**
```
Delegatable: Yes
Delegate: Maria (assistant)
Waiting-for: "Waiting: Maria to prepare monthly expense report"
Follow-up date: Friday
```

Creating the waiting-for item:
```
gtd-action add "Waiting: Maria to prepare monthly expense report" --priority 4 --due friday
```

**Agent:** "Done. Remember to actually ask Maria to do this - the waiting-for item just tracks that you're expecting it."

## The Delegation Conversation

Remind users that creating a waiting-for item doesn't actually delegate the work. They still need to:

1. Communicate the request clearly
2. Provide any needed context or resources
3. Agree on timeline and expectations
4. Confirm understanding

## Tools Used

- `gtd-action add --priority 4` - Create waiting-for items
