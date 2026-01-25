module GTD
  module Reminders
    class Error < StandardError; end
    class UnknownCommand < Error; end

    class CLI
      HELP_TEXT = <<~HELP
        gtd-reminders - Reminders.app CLI wrapper (remindctl)

        This tool functions as a 'tickler file' - reminders that surface on specific dates.

        Commands:
          list [LIST]           List reminders (default: all lists)
          add TEXT              Create a reminder
          add TEXT --due DATE   Create reminder with due date
          edit ID [OPTIONS]     Edit a reminder
          complete ID           Mark reminder complete
          delete ID             Delete a reminder
          lists                 Show available reminder lists
          due                   Show reminders due today
          overdue               Show overdue reminders

        Note: Requires Reminders access permission
          System Settings > Privacy & Security > Reminders
      HELP

      DATE_ONLY_PATTERN = /^\d{4}-\d{2}-\d{2}$/

      def initialize(argv)
        @command = argv[0]
        @args = argv[1..]
      end

      def run
        case @command
        when 'list', 'l'
          list_reminders
        when 'add', 'new'
          add_reminder
        when 'edit', 'update'
          edit_reminder
        when 'complete', 'c', 'done'
          complete_reminder
        when 'delete', 'd', 'remove'
          delete_reminder
        when 'lists'
          list_lists
        when 'due', 'today'
          show_due_today
        when 'overdue'
          show_overdue
        when 'help', '-h', '--help', nil
          puts HELP_TEXT
          0
        else
          raise UnknownCommand, @command
        end
      end

      private

      def list_reminders
        system('remindctl', 'list', *@args) ? 0 : 1
      end

      def add_reminder
        due_value = extract_due_value(@args)

        if due_value && date_only?(due_value)
          add_reminder_with_date_only_due(due_value)
        else
          system('remindctl', 'add', *@args) ? 0 : 1
        end
      end

      def add_reminder_with_date_only_due(due_value)
        output_format = detect_output_format(@args)
        args_without_format = strip_output_flags(@args)

        case output_format
        when 'standard'
          raw_output = `remindctl add --plain #{args_without_format.shelljoin}`
          return 1 unless $?.success?

          fields = raw_output.strip.split("\t")
          reminder_id = fields[0]
          set_date_only_due(reminder_id, due_value)

          list_name = fields[1]
          title = fields[5..-1].join("\t")
          puts "✓ #{title} [#{list_name}] — #{due_value}"
        when 'plain'
          raw_output = `remindctl add #{@args.shelljoin}`
          return 1 unless $?.success?

          fields = raw_output.strip.split("\t")
          reminder_id = fields[0]
          set_date_only_due(reminder_id, due_value)
          puts raw_output
        when 'json'
          raw_output = `remindctl add #{@args.shelljoin}`
          return 1 unless $?.success?

          require 'json'
          data = JSON.parse(raw_output)
          reminder_id = data['id']
          set_date_only_due(reminder_id, due_value)
          puts raw_output
        when 'quiet'
          raw_output = `remindctl add --plain #{args_without_format.shelljoin}`
          return 1 unless $?.success?

          fields = raw_output.strip.split("\t")
          reminder_id = fields[0]
          set_date_only_due(reminder_id, due_value)
        end
        0
      end

      def edit_reminder
        system('remindctl', 'edit', *@args) ? 0 : 1
      end

      def complete_reminder
        system('remindctl', 'complete', *@args) ? 0 : 1
      end

      def delete_reminder
        system('remindctl', 'delete', *@args) ? 0 : 1
      end

      def list_lists
        system('remindctl', 'list') ? 0 : 1
      end

      def show_due_today
        system('remindctl', 'show', 'today', *@args) ? 0 : 1
      end

      def show_overdue
        system('remindctl', 'show', 'overdue', *@args) ? 0 : 1
      end

      def extract_due_value(args)
        args.each_with_index do |arg, i|
          if ['--due', '-d'].include?(arg) && i + 1 < args.length
            return args[i + 1]
          end
        end
        nil
      end

      def date_only?(value)
        value.match?(DATE_ONLY_PATTERN)
      end

      def detect_output_format(args)
        return 'json' if args.include?('--json')
        return 'plain' if args.include?('--plain')
        return 'quiet' if args.include?('--quiet')
        'standard'
      end

      def strip_output_flags(args)
        args.reject { |arg| ['--json', '--plain', '--quiet'].include?(arg) }
      end

      def set_date_only_due(reminder_id, due_value)
        script_path = File.expand_path('../../../tools/_gtd-reminders/set-date-only-due.swift', __dir__)
        system('/usr/bin/swift', script_path, reminder_id, due_value)
      end
    end
  end
end
