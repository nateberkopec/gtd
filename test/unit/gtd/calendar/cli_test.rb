require 'test_helper'
require_relative '../../../../lib/gtd/calendar/cli'

class GTD::Calendar::CLITest < Minitest::Test
  def test_help_displays_usage_by_default
    cli = GTD::Calendar::CLI.new([])
    output = capture_io { cli.run }.first
    assert_match /gtd-calendar - Calendar CLI wrapper/, output
    assert_match /Commands:/, output
    assert_match /Configuration:/, output
  end

  def test_help_command_displays_usage
    cli = GTD::Calendar::CLI.new(['help'])
    output = capture_io { cli.run }.first
    assert_match /gtd-calendar - Calendar CLI wrapper/, output
  end

  def test_list_with_default_days
    cli = GTD::Calendar::CLI.new(['list'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['khal', 'list', '--days', '7'], system_calls[0]
    end
  end

  def test_list_with_custom_days
    cli = GTD::Calendar::CLI.new(['list', '14'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['khal', 'list', '--days', '14'], system_calls[0]
    end
  end

  def test_today_lists_one_day
    cli = GTD::Calendar::CLI.new(['today'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['khal', 'list', '--days', '1'], system_calls[0]
    end
  end

  def test_tomorrow_lists_two_days_skipping_first_line
    cli = GTD::Calendar::CLI.new(['tomorrow'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['sh', '-c', 'khal list --days 2 | tail -n +2'], system_calls[0]
    end
  end

  def test_add_without_args
    cli = GTD::Calendar::CLI.new(['add'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['khal', 'new'], system_calls[0]
    end
  end

  def test_add_with_summary
    cli = GTD::Calendar::CLI.new(['new', 'Meeting', 'with', 'team'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['khal', 'new', 'Meeting', 'with', 'team'], system_calls[0]
    end
  end

  def test_edit_event
    cli = GTD::Calendar::CLI.new(['edit', '12345'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['khal', 'edit', '12345'], system_calls[0]
    end
  end

  def test_delete_event
    cli = GTD::Calendar::CLI.new(['delete', '12345'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['khal', 'edit', '--delete', '12345'], system_calls[0]
    end
  end

  def test_sync_calendars
    cli = GTD::Calendar::CLI.new(['sync'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['vdirsyncer', 'sync'], system_calls[0]
    end
  end

  def test_interactive_calendar
    cli = GTD::Calendar::CLI.new(['interactive'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal ['ikhal'], system_calls[0]
    end
  end

  def test_l_is_alias_for_list
    cli = GTD::Calendar::CLI.new(['l'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['khal', 'list', '--days', '7'], system_calls[0]
    end
  end

  def test_unknown_command_raises_error
    cli = GTD::Calendar::CLI.new(['unknown'])
    error = assert_raises(GTD::Calendar::UnknownCommand) { cli.run }
    assert_equal 'unknown', error.message
  end
end
