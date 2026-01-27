module GTD
  module Email
    class Error < StandardError; end
    class MissingArgument < Error; end
    class UnknownCommand < Error; end

    class CLI
      HELP_TEXT = <<~HELP
        gtd-email - Email CLI wrapper (himalaya)

        Commands:
          list [--folder FOLDER]  List emails (default: INBOX)
          read ID                 Read email content
          archive ID              Archive email (move to Archive)
          delete ID               Delete email
          move ID FOLDER          Move email to folder
          folders                 List available folders
          search QUERY            Search emails

        Configuration:
          Run 'himalaya' for interactive setup
          Config: ~/.config/himalaya/config.toml
      HELP

      def initialize(argv)
        @command = argv[0]
        @args = argv[1..]
      end

      def run
        case @command
        when 'list', 'l'
          list_emails
        when 'read', 'r'
          read_email
        when 'archive', 'a'
          archive_email
        when 'delete', 'd'
          delete_email
        when 'move', 'm'
          move_email
        when 'folders'
          list_folders
        when 'search', 's'
          search_emails
        when 'help', '-h', '--help', nil
          puts HELP_TEXT
          0
        else
          raise UnknownCommand, @command
        end
      end

      private

      def list_emails
        system('himalaya', 'envelope', 'list', *@args, err: File::NULL)
        $?.success? ? 0 : 1
      end

      def read_email
        raise MissingArgument, 'read requires an email ID' if @args.empty?
        system('himalaya', 'message', 'read', *@args, err: File::NULL)
        $?.success? ? 0 : 1
      end

      def archive_email
        raise MissingArgument, 'archive requires an email ID' if @args.empty?
        system('himalaya', 'message', 'move', 'Archive', *@args, err: File::NULL)
        $?.success? ? 0 : 1
      end

      def delete_email
        raise MissingArgument, 'delete requires an email ID' if @args.empty?
        system('himalaya', 'message', 'delete', *@args, err: File::NULL)
        $?.success? ? 0 : 1
      end

      def move_email
        raise MissingArgument, 'move requires ID and FOLDER' if @args.size < 2
        id = @args[0]
        folder = @args[1]
        system('himalaya', 'message', 'move', folder, id, err: File::NULL)
        $?.success? ? 0 : 1
      end

      def list_folders
        system('himalaya', 'folder', 'list', err: File::NULL)
        $?.success? ? 0 : 1
      end

      def search_emails
        raise MissingArgument, 'search requires a query' if @args.empty?
        system('himalaya', 'envelope', 'list', '--query', @args.join(' '), err: File::NULL)
        $?.success? ? 0 : 1
      end
    end
  end
end
