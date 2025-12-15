# frozen_string_literal: true

require "optparse"
require_relative "../todoist_client"

module GTD
  module CLI
    class TodoGet
      attr_reader :options

      def initialize
        @options = {}
      end

      def run(argv = ARGV)
        parse_options(argv)
        fetch_and_display_tasks
      end

      private

      def parse_options(argv)
        build_option_parser.parse!(argv)
      rescue OptionParser::InvalidOption => e
        abort_with_usage(e.message)
      end

      def build_option_parser
        OptionParser.new do |opts|
          opts.banner = "Usage: todo-get [options]"
          add_project_option(opts)
          add_help_option(opts)
        end
      end

      def add_project_option(opts)
        opts.on("-p", "--project PROJECT_NAME", "Get tasks from a specific project") do |project|
          options[:project] = project
        end
      end

      def add_help_option(opts)
        opts.on("-h", "--help", "Display this help message") { display_help(opts) }
      end

      def display_help(opts)
        puts opts
        exit 0
      end

      def abort_with_usage(message)
        puts message
        puts build_option_parser
        exit 1
      end

      def fetch_and_display_tasks
        tasks = fetch_tasks
        display_tasks(tasks)
      rescue => e
        warn "Error: #{e.message}"
        exit 1
      end

      def fetch_tasks
        log_fetch_message
        options[:project] ? client.get_tasks_by_project(options[:project]) : client.get_tasks
      end

      def client
        @client ||= TodoistClient.new
      end

      def log_fetch_message
        return unless $VERBOSE

        puts options[:project] ? "Fetching tasks for project: #{options[:project]}" : "Fetching all tasks"
      end

      def display_tasks(tasks)
        return puts empty_message if tasks.empty?

        tasks.each { |task| puts format_task(task) }
      end

      def empty_message
        suffix = options[:project] ? " for project #{options[:project]}" : ""
        "No tasks found#{suffix}"
      end

      def format_task(task)
        content = task["content"]
        tags = format_tags(task["labels"] || [])
        tags.empty? ? content : "#{content} #{tags}"
      end

      def format_tags(labels)
        labels.map { |l| "@#{l}" }.join(" ")
      end
    end
  end
end
