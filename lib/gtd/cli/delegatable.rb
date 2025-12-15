# frozen_string_literal: true

require_relative "llm_batch_processor"

module GTD
  module CLI
    class Delegatable < LLMBatchProcessor
      private

      def default_options
        super.merge(only_delegatable: true)
      end

      def system_prompt
        <<~PROMPT
          You are an expert in task management and delegation.
          Your role is to analyze tasks and determine if they could be effectively delegated to:
          1. An Executive Assistant (EA)
          2. Artificial Intelligence (AI)

          Guidelines for delegation:

          EA-Suitable Tasks:
          - Administrative work (scheduling, travel arrangements, filing)
          - Research that does not require domain expertise
          - Email management and correspondence
          - Data entry and organization
          - Basic financial tasks (expense reports, invoicing)
          - Meeting coordination
          - Document preparation and formatting

          AI-Suitable Tasks:
          - Data analysis and processing
          - Content generation or editing
          - Translation work
          - Basic research and summarization
          - Image or media processing
          - Code review or documentation
          - Pattern recognition tasks

          NOT Delegatable Tasks:
          - Strategic decisions
          - Personal relationships and networking
          - Creative direction
          - Core business strategy
          - Personal commitments
          - Tasks requiring a human's unique expertise or perspective

          For each task, respond with either:
          - "DELEGATE TO EA: <reason>" if suitable for an EA
          - "AI TASK: <reason>" if it could be handled by AI
          - "NOT DELEGATABLE: <reason>" if it requires personal attention

          Provide a brief explanation of why it fits the category you chose, and what the next action would be to get the EA or AI to complete the task. If the resulting next action would take less than 5 minutes, suggest doing it immediately.

          Return your answers with the same numbering as the input, ensuring each response is on a new line.
        PROMPT
      end

      def description
        "Analyze tasks to determine if they can be delegated to an EA or AI."
      end

      def usage_examples
        [
          "echo 'Schedule meeting with Bob' | delegatable",
          "cat tasks.txt | delegatable"
        ]
      end

      def configure_options(opts)
        opts.on("-a", "--all", "Show all tasks (including non-delegatable)") do
          options[:only_delegatable] = false
        end
      end

      def filter_results(results)
        return results unless options[:only_delegatable]

        results.reject { |r| r[:result]&.start_with?("NOT DELEGATABLE") }
      end
    end
  end
end
