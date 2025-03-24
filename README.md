# GTD Command Line Tools

A set of command-line utilities that integrate with Todoist and OpenAI to help implement the Getting Things Done (GTD) methodology.

## Features

- `todo-get`: Retrieves and displays all your tasks from Todoist
- `next-action`: Analyzes a task and rewrites it as a clear, actionable "next action" following GTD principles
- `openai-models`: Lists available OpenAI models for use with the `next-action` command/your .env

## Installation

1. Clone this repository:
   ```
   git clone <repository-url>
   cd gtd
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up your environment variables:
   ```
   cp .env.example .env
   ```

4. Edit the `.env` file with your API keys:
   - Get your Todoist API token from Todoist settings -> Integrations -> API token
   - Get your OpenAI API key from [platform.openai.com](https://platform.openai.com)


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

### `openai-models`

List all available OpenAI models for your account:

```
openai-models
```

The model used for the `next-action` command can be configured in your `.env` file by setting the `OPENAI_MODEL` variable.

## Using Pipes

These commands work well with standard Unix pipes. Here are some useful examples:

### Limiting Output

To limit the output to the first 10 lines:

```
todo-get | head -n 10
```

### Filtering and Processing

Process tasks in OpenAI network call batches of 20 (default 10):

```
todo-get | head -n 40 | next-action --batch 20
```

## License

MIT
