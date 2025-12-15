# frozen_string_literal: true

require_relative "llm_batch_processor"

module GTD
  module CLI
    class NextAction < LLMBatchProcessor
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
            Reworded: "Draft list of specific website changes needed for homepage refresh"

          - Vague: "Mom's birthday"
            Reworded: "Call flower shop at (555) 123-4567 to order arrangement for delivery on 5/15"

          - Vague: "Follow up with client"
            Reworded: "Email Alex at alex@example.com to request project timeline update"

          - Vague: "Research vacation options"
            Reworded: "Create Google Doc with 3 potential destinations and estimated costs for July trip"

          Make your rewording concise, usually less than 140 characters, but specific.

          For each numbered task I provide, reword it as a specific next action.
          Return your answers with the same numbering, ensuring each response is on a new line.
          Output ONLY the reworded task - do not prefix with "Next action:" or any other label.
          Judge if each task is doable in less than 2 minutes (write "DO IT NOW" if so), is already an effectively worded next action (write "N/A" if so), or could be significantly improved with rewording.
        PROMPT
      end

      def description
        "Rewrite tasks as GTD next actions using an LLM."
      end

      def usage_examples
        [
          "echo 'Update the website' | next-action",
          "cat tasks.txt | next-action"
        ]
      end
    end
  end
end
