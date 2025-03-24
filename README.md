# GTD Command Line Tools

A set of command-line utilities that integrate with Todoist and OpenAI to help implement the Getting Things Done (GTD) methodology.

## Features

- `todo-get`: Retrieves and displays all your tasks from Todoist
- `next-action`: Analyzes a task and rewrites it as a clear, actionable "next action" following GTD principles
- `openai-models`: Lists available OpenAI models for use with the `next-action` command

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

5. Add the `bin` directory to your PATH or create symlinks to the executables:
   ```
   # Option 1: Add to PATH in your shell profile (.bashrc, .zshrc, etc.)
   export PATH="$PATH:/path/to/gtd/bin"

   # Option 2: Create symlinks in a directory already in your PATH
   ln -s /path/to/gtd/bin/todo-get /usr/local/bin/todo-get
   ln -s /path/to/gtd/bin/next-action /usr/local/bin/next-action
   ln -s /path/to/gtd/bin/openai-models /usr/local/bin/openai-models
   ```

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

Get help:

```
todo-get --help
```

### `next-action`

Rewrite a task as a GTD next action:

```
echo "Plan vacation" | next-action
```

This will output something like: "Create a list of 3 possible vacation destinations with available dates and budget estimates"

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

Filter models by name (useful for finding specific model versions):

```
openai-models --filter gpt-4
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

Get only tasks containing "Project" and limit to first 5:

```
todo-get | grep "Project" | head -n 5
```

Process the first 3 tasks into next actions:

```
todo-get | head -n 3 | while read -r line; do echo "$line" | next-action; done
```

Fetch tasks from a specific project, limit to 10, and save to a file:

```
todo-get --project "Work" | head -n 10 > work_tasks.txt
```

## License

MIT
