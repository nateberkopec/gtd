require 'test_helper'
require 'gtd/mindsweep/cli'

class GTD::Mindsweep::CLITest < Minitest::Test
  def test_displays_header_and_footer_by_default
    cli = GTD::Mindsweep::CLI.new
    triggers = ["Line 1\n"]

    cli.stub :triggers_file_exists?, true do
      File.stub :readlines, triggers do
        cli.stub :sleep, ->(_) {} do
          output = capture_io { cli.run }.first
          assert_includes output, '=== Mind Sweep ==='
          assert_includes output, '=== Mind Sweep Complete ==='
          assert_match /Watch the triggers scroll/, output
        end
      end
    end
  end

  def test_raises_error_if_triggers_file_missing
    cli = GTD::Mindsweep::CLI.new

    cli.stub :triggers_file_exists?, false do
      assert_raises(GTD::Mindsweep::MissingTriggersFile) { cli.run }
    end
  end

  def test_displays_each_trigger_with_delay
    cli = GTD::Mindsweep::CLI.new
    triggers = ["Trigger 1\n", "Trigger 2\n", "Trigger 3\n"]

    sleep_calls = []

    cli.stub :triggers_file_exists?, true do
      File.stub :readlines, triggers do
        cli.stub :sleep, ->(duration) { sleep_calls << duration } do
          output = capture_io { cli.run }.first

          assert_match /Trigger 1/, output
          assert_match /Trigger 2/, output
          assert_match /Trigger 3/, output

          assert sleep_calls.count(0.5) >= 3
          assert_includes sleep_calls, 1
        end
      end
    end
  end
end
