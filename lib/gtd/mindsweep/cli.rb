module GTD
  module Mindsweep
    class Error < StandardError; end
    class MissingTriggersFile < Error; end

    class CLI
      attr_reader :triggers_file

      def initialize(argv = [], script_dir: nil)
        @script_dir = script_dir || File.expand_path('../../../tools/gtd-mindsweep', __dir__)
        @triggers_file = File.join(@script_dir, 'sweep_triggers.txt')
      end

      def run
        raise MissingTriggersFile unless triggers_file_exists?

        puts "=== Mind Sweep ==="
        puts "Watch the triggers scroll by. Capture anything that has your attention."
        puts
        sleep 1

        File.readlines(@triggers_file).each do |line|
          puts line
          sleep 0.5
        end

        puts
        puts "=== Mind Sweep Complete ==="
        0
      end

      private

      def triggers_file_exists?
        File.exist?(@triggers_file)
      end
    end
  end
end
