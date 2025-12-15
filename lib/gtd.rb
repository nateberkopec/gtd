require_relative "gtd/config"
require_relative "gtd/todoist_client"
require_relative "gtd/cli/llm_batch_processor"
require_relative "gtd/cli/suggest_context"
require_relative "gtd/cli/next_action"
require_relative "gtd/cli/delegatable"
require_relative "gtd/cli/todo_get"

module GTD
  VERSION = "0.2.0"
end
