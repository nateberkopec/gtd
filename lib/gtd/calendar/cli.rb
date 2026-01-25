module GTD
  module Calendar
    class Error < StandardError; end
    class UnknownCommand < Error; end

    class CLI
      HELP_TEXT = <<~HELP
        gtd-calendar - Calendar CLI wrapper (khal + vdirsyncer)

        Commands:
          list [DAYS]       List events (default: next 7 days)
          today             List today's events
          tomorrow          List tomorrow's events
          add               Add an event interactively
          new SUMMARY       Quick add event
          edit              Edit events interactively
          delete            Delete an event
          sync              Sync calendars with server (vdirsyncer)
          interactive       Open interactive calendar (ikhal)

        Configuration:
          khal config: ~/.config/khal/config
          vdirsyncer config: ~/.config/vdirsyncer/config
      HELP

      def initialize(argv)
        @command = argv[0]
        @args = argv[1..]
        ensure_path_includes_local_bin
      end

      def run
        case @command
        when 'list', 'l'
          list_events
        when 'today'
          today_events
        when 'tomorrow'
          tomorrow_events
        when 'add', 'new'
          add_event
        when 'edit', 'e'
          edit_event
        when 'delete', 'd'
          delete_event
        when 'sync', 's'
          sync_calendars
        when 'interactive', 'i', 'ikhal'
          interactive_calendar
        when 'help', '-h', '--help', nil
          puts HELP_TEXT
          0
        else
          raise UnknownCommand, @command
        end
      end

      private

      def ensure_path_includes_local_bin
        local_bin = File.expand_path('~/.local/bin')
        ENV['PATH'] = "#{ENV['PATH']}:#{local_bin}" unless ENV['PATH'].include?(local_bin)
      end

      def list_events
        days = @args[0] || '7'
        result = system('khal', 'list', '--days', days)
        result ? 0 : 1
      end

      def today_events
        result = system('khal', 'list', '--days', '1')
        result ? 0 : 1
      end

      def tomorrow_events
        # List 2 days but skip the first line (today's header)
        result = system('sh', '-c', 'khal list --days 2 | tail -n +2')
        result ? 0 : 1
      end

      def add_event
        result = if @args.empty?
          system('khal', 'new')
        else
          system('khal', 'new', *@args)
        end
        result ? 0 : 1
      end

      def edit_event
        result = system('khal', 'edit', *@args)
        result ? 0 : 1
      end

      def delete_event
        result = system('khal', 'edit', '--delete', *@args)
        result ? 0 : 1
      end

      def sync_calendars
        result = system('vdirsyncer', 'sync')
        result ? 0 : 1
      end

      def interactive_calendar
        result = system('ikhal', *@args)
        result ? 0 : 1
      end
    end
  end
end
