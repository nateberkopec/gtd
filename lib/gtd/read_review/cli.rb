require 'uri'

module GTD
  module ReadReview
    class Error < StandardError; end
    class MissingURL < Error; end
    class UnknownCommand < Error; end

    class CLI
      HELP_TEXT = <<~HELP
        gtd-read-review - Save URLs to read-later service (Matter)

        Commands:
          add URL    Save a URL to Matter for later reading

        Examples:
          gtd-read-review add https://example.com/article
          gtd-read-review add "https://arxiv.org/abs/2512.24601"
      HELP

      def initialize(argv)
        @command = argv[0]
        @args = argv[1..]
      end

      def run
        case @command
        when 'add', 'a', 'save', 's'
          add_url
        when 'help', '-h', '--help', nil
          puts HELP_TEXT
          0
        else
          raise UnknownCommand, @command
        end
      end

      private

      def add_url
        raise MissingURL if @args.empty?

        url = @args[0]
        encoded_url = URI.encode_www_form_component(url)
        system('open', "https://web.getmatter.com/save?url=#{encoded_url}")
        puts "Saved to Matter: #{url}"
        0
      end
    end
  end
end
