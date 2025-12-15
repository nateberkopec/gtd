# frozen_string_literal: true

require "optparse"
require "concurrent"
require "open3"

module GTD
  module CLI
    class LLMBatchProcessor
      attr_reader :options

      def initialize
        @options = default_options
      end

      def run(argv = ARGV)
        parse_options(argv)
        validate_input
        process_tasks
      end

      private

      def default_options
        {batch_size: 10, verbose: false, model: nil}
      end

      def system_prompt
        raise NotImplementedError, "Subclasses must implement #system_prompt"
      end

      def banner
        "Usage: #{command_name} [options]"
      end

      def command_name
        self.class.name.split("::").last.gsub(/([a-z])([A-Z])/, '\1-\2').downcase
      end

      def description
        ""
      end

      def usage_examples
        []
      end

      def configure_options(opts)
      end

      def parse_options(argv)
        build_option_parser.parse!(argv)
      end

      def build_option_parser
        OptionParser.new do |opts|
          configure_banner(opts)
          add_help_option(opts)
          add_standard_options(opts)
          configure_options(opts)
        end
      end

      def configure_banner(opts)
        opts.banner = banner
        opts.separator ""
        opts.separator description if description && !description.empty?
        opts.separator ""
        opts.separator "Options:"
      end

      def add_help_option(opts)
        opts.on("-h", "--help", "Display this help message") { display_help(opts) }
      end

      def display_help(opts)
        puts opts
        print_usage_examples
        exit 0
      end

      def print_usage_examples
        return unless usage_examples.any?

        puts ""
        puts "Example:"
        usage_examples.each { |example| puts "  #{example}" }
      end

      def add_standard_options(opts)
        add_verbose_option(opts)
        add_batch_option(opts)
        add_model_option(opts)
      end

      def add_verbose_option(opts)
        opts.on("-v", "--verbose", "Run with verbose output") { options[:verbose] = true }
      end

      def add_batch_option(opts)
        opts.on("-b", "--batch SIZE", Integer, "Process tasks in batches of SIZE (default: 10)") do |size|
          options[:batch_size] = size
        end
      end

      def add_model_option(opts)
        opts.on("-m", "--model MODEL", "Specify LLM model to use (default: llm default)") do |model|
          options[:model] = model
        end
      end

      def validate_input
        return unless $stdin.tty?

        warn "Error: Please pipe tasks to this command"
        usage_examples.each { |example| warn "Example: #{example}" }
        exit 1
      end

      def read_tasks
        $stdin.readlines.map(&:strip).reject(&:empty?)
      end

      def process_tasks
        tasks = read_tasks
        exit_if_empty(tasks)
        log_processing_start(tasks)
        output_results(run_batches(tasks), tasks)
      end

      def exit_if_empty(tasks)
        return unless tasks.empty?

        warn "Error: No tasks received"
        exit 1
      end

      def log_processing_start(tasks)
        return unless options[:verbose]

        warn "Processing #{tasks.size} task(s) in batches of #{options[:batch_size]}"
      end

      def run_batches(tasks)
        executor = BatchExecutor.new(tasks, options, method(:process_batch), method(:build_result))
        executor.run { |result| parse_results(result) }
      end

      def process_batch(batch)
        log_batch_processing(batch)
        execute_llm_command(format_batch(batch))
      end

      def format_batch(batch)
        batch.each_with_index.map { |task, i| "#{i + 1}. #{task}" }.join("\n")
      end

      def log_batch_processing(batch)
        warn "Processing batch of #{batch.size} tasks..." if options[:verbose]
      end

      def execute_llm_command(input)
        stdout, stderr, status = Open3.capture3(*llm_command, stdin_data: input)
        return stdout if status.success?

        warn "LLM command failed: #{stderr}"
        nil
      end

      def llm_command
        cmd = ["llm"]
        cmd += ["-m", options[:model]] if options[:model]
        cmd + ["-s", system_prompt, "--no-stream"]
      end

      def parse_results(result_text)
        ResultParser.new(result_text).parse
      end

      def build_result(index, original, processed)
        {index: index, original: original, result: processed}
      end

      def filter_results(results)
        results
      end

      def format_result(result, total_count)
        output = "#{result[:original]}\n  #{result[:result]}"
        output += "\n" if total_count > 1
        output
      end

      def output_results(results, tasks)
        filter_results(results).each { |result| puts format_result(result, tasks.size) }
      end
    end

    class BatchExecutor
      def initialize(tasks, options, process_batch, build_result)
        @tasks = tasks
        @options = options
        @process_batch = process_batch
        @build_result = build_result
      end

      def run(&parse_block)
        @parse_block = parse_block
        collect_results(execute_batches).sort_by { |r| r[:index] }
      end

      private

      def execute_batches
        pool = create_thread_pool
        results = schedule_and_collect(pool)
        shutdown_pool(pool)
        results
      end

      def create_thread_pool
        Concurrent::FixedThreadPool.new([batches.size, 10].min)
      end

      def batches
        @batches ||= @tasks.each_slice(@options[:batch_size]).to_a
      end

      def schedule_and_collect(pool)
        schedule_batches(pool).map(&:value).sort_by(&:first).map(&:last)
      end

      def schedule_batches(pool)
        batches.each_with_index.map do |batch, idx|
          Concurrent::Future.execute(executor: pool) { [idx, @process_batch.call(batch)] }
        end
      end

      def shutdown_pool(pool)
        pool.shutdown
        pool.wait_for_termination
      end

      def collect_results(batch_results)
        all_results = []
        batch_results.each_with_index do |result, idx|
          append_batch_results(result, idx, all_results) if result
        end
        all_results
      end

      def append_batch_results(result, batch_index, all_results)
        batch_start = batch_index * @options[:batch_size]
        @parse_block.call(result).each_with_index do |item, i|
          all_results << @build_result.call(batch_start + i, @tasks[batch_start + i], item)
        end
      end
    end

    class ResultParser
      def initialize(result_text)
        @result_text = result_text
        @results = []
        @current_result = nil
      end

      def parse
        @result_text.each_line { |line| process_line(line.strip) }
        finalize_results
      end

      private

      def process_line(line)
        return start_new_result(line) if numbered_line?(line)

        @current_result += " #{line}" if continuation_line?(line)
      end

      def numbered_line?(line)
        line.match?(/^\d+[.)]\s+/)
      end

      def continuation_line?(line)
        !line.empty? && @current_result
      end

      def start_new_result(line)
        @results << @current_result if @current_result
        @current_result = line.sub(/^\d+[.)]\s+/, "")
      end

      def finalize_results
        @results << @current_result if @current_result
        @results
      end
    end
  end
end
