# GTD Command Line Tools

A set of command-line utilities that integrate with Todoist and the `llm` CLI to help implement the Getting Things Done (GTD) methodology.

## Features

- `todo-get`: Retrieves and displays all your tasks from Todoist
- `next-action`: Analyzes a task and rewrites it as a clear, actionable "next action" following GTD principles
- `delegatable`: Analyzes tasks to determine if they can be delegated to an EA or AI

## Prerequisites

- [llm](https://llm.datasette.io/) - Install with `pip install llm` or `brew install llm`
- Ruby (for Todoist integration)

## Installation

1. Clone this repository:
   ```
   git clone <repository-url>
   cd gtd
   ```

2. Install Ruby dependencies (for Todoist integration):
   ```
   bundle install
   ```

3. Configure the `llm` CLI with your API key:
   ```
   llm keys set openai
   ```

   Or configure another provider. See [llm documentation](https://llm.datasette.io/) for available models and providers.

4. Set up your Todoist API token:
   ```
   cp .env.example .env
   ```
   Edit the `.env` file and add your Todoist API token from Todoist settings -> Integrations -> API token.

## Usage

### `todo-get`

Display all your Todoist tasks:

```
todo-get
```

Display tasks for a specific project:

```
todo-get --project "Work"
```

### `next-action`

Rewrite a task as a GTD next action:

```
echo "Plan vacation" | next-action
```

This will output something like: "Create a list of 3 possible vacation destinations with available dates and budget estimates"

Process multiple tasks at once (more efficient):

```
cat tasks.txt | next-action
```

You can combine these tools:

```
todo-get | grep "Project" | next-action
```

Run with verbose output:

```
echo "Prepare presentation" | next-action --verbose
```

Specify a different model:

```
echo "Plan vacation" | next-action -m gpt-4o
```

### `delegatable`

Analyze tasks to see if they can be delegated:

```
echo "Schedule meeting with Bob" | delegatable
```

Show all tasks including non-delegatable:

```
cat tasks.txt | delegatable --all
```

## Using Pipes

These commands work well with standard Unix pipes. Here are some useful examples:

### Limiting Output

To limit the output to the first 10 lines:

```
todo-get | head -n 10
```

### Filtering and Processing

Process tasks in batches of 20 (default 10):

```
todo-get | head -n 40 | next-action --batch 20
```

### Full Workflow

Get tasks, find delegatable ones, and reword as next actions:

```
todo-get | delegatable --all | next-action
```

## Changing the Default Model

The `llm` CLI allows you to set a default model:

```
llm models default gpt-4o
```

Or specify a model per-command with `-m`:

```
echo "My task" | next-action -m gpt-4o-mini
```

## License

MIT
