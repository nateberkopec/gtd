require 'test_helper'
require_relative '../../../../lib/gtd/reminders/cli'

class GTD::Reminders::CLITest < Minitest::Test
  def test_help_displays_usage_by_default
    cli = GTD::Reminders::CLI.new([])
    output = capture_io { cli.run }.first
    assert_match /gtd-reminders - Reminders.app CLI wrapper/, output
    assert_match /Commands:/, output
    assert_match /tickler file/, output
  end

  def test_help_command_displays_usage
    cli = GTD::Reminders::CLI.new(['help'])
    output = capture_io { cli.run }.first
    assert_match /gtd-reminders - Reminders.app CLI wrapper/, output
  end

  def test_unknown_command_raises_error
    cli = GTD::Reminders::CLI.new(['unknown'])
    error = assert_raises(GTD::Reminders::UnknownCommand) { cli.run }
    assert_equal 'unknown', error.message
  end

  def test_list_calls_remindctl
    cli = GTD::Reminders::CLI.new(['list'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal 1, system_calls.size
      assert_equal ['remindctl', 'list'], system_calls[0]
    end
  end

  def test_list_with_args_passes_them
    cli = GTD::Reminders::CLI.new(['list', 'Work'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'list', 'Work'], system_calls[0]
    end
  end

  def test_complete_calls_remindctl
    cli = GTD::Reminders::CLI.new(['complete', '123'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'complete', '123'], system_calls[0]
    end
  end

  def test_delete_calls_remindctl
    cli = GTD::Reminders::CLI.new(['delete', '456'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'delete', '456'], system_calls[0]
    end
  end

  def test_edit_calls_remindctl
    cli = GTD::Reminders::CLI.new(['edit', '789', '--title', 'New Title'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'edit', '789', '--title', 'New Title'], system_calls[0]
    end
  end

  def test_lists_calls_remindctl_list
    cli = GTD::Reminders::CLI.new(['lists'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'list'], system_calls[0]
    end
  end

  def test_due_calls_remindctl_show_today
    cli = GTD::Reminders::CLI.new(['due'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'show', 'today'], system_calls[0]
    end
  end

  def test_overdue_calls_remindctl_show_overdue
    cli = GTD::Reminders::CLI.new(['overdue'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'show', 'overdue'], system_calls[0]
    end
  end

  def test_date_only_detection
    cli = GTD::Reminders::CLI.new([])

    assert cli.send(:date_only?, '2024-01-15')
    refute cli.send(:date_only?, '2024-01-15T10:00:00')
    refute cli.send(:date_only?, 'tomorrow')
    refute cli.send(:date_only?, '01/15/2024')
  end

  def test_extract_due_value
    cli = GTD::Reminders::CLI.new(['add', 'Test', '--due', '2024-01-15'])
    assert_equal '2024-01-15', cli.send(:extract_due_value, cli.instance_variable_get(:@args))

    cli = GTD::Reminders::CLI.new(['add', 'Test', '-d', 'tomorrow'])
    assert_equal 'tomorrow', cli.send(:extract_due_value, cli.instance_variable_get(:@args))

    cli = GTD::Reminders::CLI.new(['add', 'Test'])
    assert_nil cli.send(:extract_due_value, cli.instance_variable_get(:@args))
  end

  def test_detect_output_format
    cli = GTD::Reminders::CLI.new([])

    assert_equal 'json', cli.send(:detect_output_format, ['--json'])
    assert_equal 'plain', cli.send(:detect_output_format, ['--plain'])
    assert_equal 'quiet', cli.send(:detect_output_format, ['--quiet'])
    assert_equal 'standard', cli.send(:detect_output_format, [])
  end

  def test_strip_output_flags
    cli = GTD::Reminders::CLI.new([])

    args = ['add', 'Test', '--json', '--due', '2024-01-15']
    result = cli.send(:strip_output_flags, args)
    assert_equal ['add', 'Test', '--due', '2024-01-15'], result
  end

  def test_command_aliases
    # l for list
    cli = GTD::Reminders::CLI.new(['l'])
    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'list'], system_calls[0]
    end

    # c for complete
    cli = GTD::Reminders::CLI.new(['c', '123'])
    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run
      assert_equal ['remindctl', 'complete', '123'], system_calls[0]
    end
  end
end
