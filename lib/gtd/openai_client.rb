require 'openai'
require_relative 'config'

module GTD
  class OpenAIClient
    def initialize
      @client = OpenAI::Client.new(access_token: Config.openai_api_key)
    end

    # Process a task and reword it as a "next action" using GPT
    def process_next_action(task_description)
      tasks = [task_description]
      results = process_next_actions(tasks)
      results.first
    end

    # Process multiple tasks in a single API call
    def process_next_actions(task_descriptions)
      return [] if task_descriptions.empty?

      # Create a formatted message with all tasks
      formatted_tasks = task_descriptions.map.with_index do |task, index|
        "#{index + 1}. #{task}"
      end.join("\n")

      response = @client.chat(
        parameters: {
          model: Config.openai_model,
          messages: [
            { role: "system", content: system_prompt + "\n" + system_prompt_batch },
            { role: "user", content: "Judge if each of these tasks is doable in less than 2 minutes (write 'DO IT NOW' if so), is already an effectively worded next action (write 'N/A' if so), or could be significantly improved with rewording. The tasks are: \n#{formatted_tasks}" }
          ],
          temperature: 0.7
        }
      )

      if response.dig('error')
        STDERR.puts "Error from OpenAI API: #{response.dig('error', 'message')}"
        return task_descriptions
      end

      content = response.dig('choices', 0, 'message', 'content').strip

      # Parse the response to extract individual next actions
      parse_response(content, task_descriptions)
    end

    private

    def parse_response(content, original_tasks)
      lines = content.split("\n")
      results = []
      current_action = ""

      lines.each do |line|
        # Look for lines starting with a number followed by a period or parenthesis
        if line.match(/^\s*\d+[\.\)]\s+/)
          # Save the previous action if we have one
          results << current_action.strip unless current_action.empty?
          # Start a new action, removing the numbering
          current_action = line.sub(/^\s*\d+[\.\)]\s+/, '')
        else
          # Continue the current action
          current_action += " " + line.strip unless line.strip.empty?
        end
      end

      # Add the last action
      results << current_action.strip unless current_action.empty?

      # Make sure we have the same number of results as inputs
      # If not, pad with original tasks
      if results.size < original_tasks.size
        results += original_tasks[results.size..-1]
      elsif results.size > original_tasks.size
        results = results[0...original_tasks.size]
      end

      results
    end

    def system_prompt
      <<~PROMPT
        You are an expert in GTD (Getting Things Done) methodology.
        Your task is to reword vague or complex tasks into clear, specific, physical next actions.

        Guidelines for effective next actions:

        1. Begin with a physical, visible action verb (e.g., "Call," "Email," "Draft," "Schedule")
        2. Be specific about what needs to be done
        3. Include enough context to act without needing more information
        4. Focus on the very next physical action, not the overall project
        5. If it requires less than 2 minutes, suggest doing it immediately

        Examples:
        - Vague: "Website update"
          Next action: "Draft list of specific website changes needed for homepage refresh"

        - Vague: "Mom's birthday"
          Next action: "Call flower shop at (555) 123-4567 to order arrangement for delivery on 5/15"

        - Vague: "Follow up with client"
          Next action: "Email Alex at alex@example.com to request project timeline update"

        - Vague: "Research vacation options"
          Next action: "Create Google Doc with 3 potential destinations and estimated costs for July trip"

        Make your rewording concise, usually less than 140 characters, but specific.
      PROMPT
    end

    def system_prompt_batch
      <<~PROMPT
        For each numbered task I provide, reword it as a specific next action.
        Return your answers with the same numbering, ensuring each response is on a new line.
      PROMPT
    end
  end
end
