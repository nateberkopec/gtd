# GTD Command Line Tools

A set of command-line utilities that integrate with Todoist and OpenAI to help implement the Getting Things Done (GTD) methodology.

## Features

- `todo-get`: Retrieves and displays all your tasks from Todoist
- `next-action`: Analyzes a task and rewrites it as a clear, actionable "next action" following GTD principles

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

## License

MIT
