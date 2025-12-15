# GTD Command Line Tools

Tools that work with Todoist and the `llm` CLI. They help you get things done.

With these tools you can:
- Turn vague tasks into clear next actions
- Find tasks to give to others
- Add context tags to tasks
- See all your Todoist tasks

## What You Need

- [mise](https://mise.jdx.dev/) - Loads Ruby and reads your `.env` file
- [llm](https://llm.datasette.io/) - Install with `pip install llm` or `brew install llm`
- A Todoist account

## Setup

1. Clone this repo:
   ```
   git clone <repository-url>
   cd gtd
   ```

2. Install Ruby gems:
   ```
   bundle install
   ```

3. Set up your `llm` API key:
   ```
   llm keys set openai
   ```
   See the [llm docs](https://llm.datasette.io/) for other models.

4. Add your Todoist API token to a `.env` file:
   ```
   echo "TODOIST_API_TOKEN=your_token_here" > .env
   ```
   Find your token in Todoist: Settings → Integrations → API token.

5. Trust mise to load the `.env` file:
   ```
   mise trust
   ```

## Commands

### `todo-get`

Shows all your Todoist tasks.

```
todo-get
```

Show tasks from one project:

```
todo-get -p "Work"
todo-get --project "Work"
```

### `next-action`

Makes vague tasks clear. It tells you what to do next.

Pipe a task to the command:

```
echo "Plan vacation" | next-action
```

You might see: "Make a list of 3 places with dates and costs"

Process many tasks at once:

```
cat tasks.txt | next-action
```

Options:
- `-v, --verbose` - Show more detail
- `-b, --batch SIZE` - Group size (default: 10)
- `-m, --model MODEL` - Pick an LLM model

### `delegatable`

Finds tasks you can give to an assistant or AI.

```
echo "Schedule meeting with Bob" | delegatable
```

This only shows tasks you can hand off. To see all tasks:

```
cat tasks.txt | delegatable -a
cat tasks.txt | delegatable --all
```

Options:
- `-a, --all` - Show all tasks
- `-v, --verbose` - Show more detail
- `-b, --batch SIZE` - Group size (default: 10)
- `-m, --model MODEL` - Pick an LLM model

### `suggest-context`

Adds tags to tasks. Tags tell you where or when you can do a task.

```
echo "Call mom about dinner" | suggest-context
```

Output:
```
Call mom about dinner
  @calls @quick @anywhere
```

See all tags:

```
suggest-context -l
suggest-context --list
```

Tags you can use:

| Tag | What it means |
|-----|---------------|
| `@quick` | Under 2 minutes |
| `@home` | Must be at home |
| `@errand` | Must go out |
| `@anywhere` | Any place works |
| `@calls` | Need to call |
| `@high_energy` | Need focus |
| `@low_energy` | OK when tired |
| `@va` | Give to assistant |
| `@fun` | Fun to do |
| `@ai` | LLM can help |
| `@thinking` | Deep thought needed |

Options:
- `-l, --list` - Show all tags
- `-v, --verbose` - Show more detail
- `-b, --batch SIZE` - Group size (default: 10)
- `-m, --model MODEL` - Pick an LLM model

## Pipes and Workflows

These tools work well with Unix pipes.

Get the first 10 tasks:

```
todo-get | head -n 10
```

Use larger batches:

```
todo-get | head -n 40 | next-action -b 20
```

Find tasks to hand off, then make them clear:

```
todo-get | delegatable | next-action
```

Add tags to your tasks:

```
todo-get | suggest-context
```

## Pick a Model

Set a default model for all `llm` calls:

```
llm models default gpt-4o
```

Or pick one for a single call:

```
echo "My task" | next-action -m gpt-4o-mini
```

## Files and Folders

```
bin/           - Commands you can run
lib/gtd/       - Ruby code
  cli/         - Code for each command
  config.rb    - Settings
  todoist_client.rb - Talks to Todoist
```

## License

MIT
