# frozen_string_literal: true

require_relative "llm_batch_processor"

module GTD
  module CLI
    class SuggestContext < LLMBatchProcessor
      CONTEXT_DESCRIPTIONS = {
        "@quick" => "Can be done in under 2 minutes",
        "@home" => "Requires being at home",
        "@errand" => "Requires leaving the house",
        "@anywhere" => "Can be done from any location",
        "@calls" => "Requires making phone calls",
        "@high_energy" => "Requires focus and mental energy",
        "@low_energy" => "Can be done when tired or distracted",
        "@va" => "Can be delegated to a virtual assistant",
        "@fun" => "Enjoyable or rewarding task",
        "@ai" => "Can be assisted or done with an LLM",
        "@thinking" => "Requires deep thought or planning"
      }.freeze

      VALID_CONTEXTS = CONTEXT_DESCRIPTIONS.keys.freeze

      private

      def system_prompt
        <<~PROMPT
          You are an expert in GTD (Getting Things Done) methodology.
          Your task is to suggest appropriate context tags for tasks.

          Available context tags and their meanings:
          - @quick: Task can be completed in under 2 minutes
          - @home: Task requires being at home (e.g., chores, home projects)
          - @errand: Task requires leaving the house (e.g., shopping, appointments)
          - @anywhere: Task can be done from any location
          - @calls: Task requires making phone calls
          - @high_energy: Task requires focus, concentration, or mental energy
          - @low_energy: Task can be done when tired, distracted, or in low-focus mode
          - @va: Task can be delegated to a virtual assistant
          - @fun: Task is enjoyable, rewarding, or something to look forward to
          - @ai: Task can be assisted or done completely with an LLM/AI tool
          - @thinking: Task requires deep thought, planning, or creative brainstorming

          Guidelines:
          1. Suggest 1-3 most relevant context tags per task
          2. Consider the physical location, energy level, and tools required
          3. @quick and @high_energy are mutually exclusive (quick tasks don't need high energy)
          4. @home and @errand are mutually exclusive
          5. @va and @ai can overlap (some tasks suit both)
          6. Prefer fewer, more accurate tags over many marginal ones

          For each numbered task, suggest the appropriate context tags.
          Return your answers with the same numbering, with ONLY the suggested tags separated by spaces.
          Do not include explanations or any other text.

          Example input:
          1. Call dentist to schedule cleaning
          2. Research best practices for React testing

          Example output:
          1. @calls @quick @anywhere
          2. @ai @high_energy @anywhere
        PROMPT
      end

      def description
        "Suggest GTD context tags for tasks using an LLM.\n\nValid contexts: #{VALID_CONTEXTS.join(", ")}"
      end

      def usage_examples
        ["echo 'Call mom about dinner plans' | suggest-context", "cat tasks.txt | suggest-context"]
      end

      def configure_options(opts)
        opts.on("-l", "--list", "List all valid context tags") { display_context_list }
      end

      def display_context_list
        puts "Valid context tags:"
        CONTEXT_DESCRIPTIONS.each { |tag, desc| puts "  #{tag.ljust(12)} - #{desc}" }
        exit 0
      end

      def build_result(index, original, processed)
        {index: index, original: original, result: validate_contexts(processed)}
      end

      def validate_contexts(context_string)
        context_string.scan(/@\w+/).select { |c| VALID_CONTEXTS.include?(c) }
      end

      def format_result(result, total_count)
        output = "#{result[:original]}\n  #{result[:result].join(" ")}"
        output += "\n" if total_count > 1
        output
      end
    end
  end
end
