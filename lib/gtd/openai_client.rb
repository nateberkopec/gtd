require 'openai'
require_relative 'config'

module GTD
  class OpenAIClient
    def initialize
      OpenAI.configure do |config|
        config.access_token = Config.openai_api_key
      end
      @client = OpenAI::Client.new
    end

    # Process a task and reword it as a "next action" using GPT
    def process_next_action(task_description)
      response = @client.chat(
        parameters: {
          model: Config.openai_model,
          messages: [
            { role: "system", content: system_prompt },
            { role: "user", content: "Reword this task as a specific next action: #{task_description}" }
          ],
          temperature: 0.7
        }
      )

      if response['error']
        STDERR.puts "Error from OpenAI API: #{response['error']['message']}"
        return task_description
      end

      response.dig('choices', 0, 'message', 'content').strip
    end

    private

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

        Make your rewording concise but specific.
      PROMPT
    end
  end
end
