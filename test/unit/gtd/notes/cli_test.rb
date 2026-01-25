require 'test_helper'
require_relative '../../../../lib/gtd/notes/cli'

class GTD::Notes::CLITest < Minitest::Test
  def test_help_displays_usage_by_default
    cli = GTD::Notes::CLI.new([])
    output = capture_io { cli.run }.first
    assert_match /gtd-notes - Apple Notes CLI wrapper/, output
    assert_match /Commands:/, output
  end

  def test_help_command_displays_usage
    cli = GTD::Notes::CLI.new(['help'])
    output = capture_io { cli.run }.first
    assert_match /gtd-notes - Apple Notes CLI wrapper/, output
  end

  def test_list_calls_notes_list
    cli = GTD::Notes::CLI.new(['list'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 1, system_calls.size
      assert_equal 'notes', system_calls[0][0]
      assert_equal 'list', system_calls[0][1]
    end
  end

  def test_list_with_folder_passes_args
    cli = GTD::Notes::CLI.new(['list', '--folder', 'MyFolder'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal ['notes', 'list', '--folder', 'MyFolder'], system_calls[0]
    end
  end

  def test_cat_calls_notes_cat
    cli = GTD::Notes::CLI.new(['cat', 'My Note'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal ['notes', 'cat', 'My Note'], system_calls[0]
    end
  end

  def test_add_calls_notes_add
    cli = GTD::Notes::CLI.new(['add', 'Some text'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal ['notes', 'add', 'Some text'], system_calls[0]
    end
  end

  def test_search_calls_notes_list
    cli = GTD::Notes::CLI.new(['search', 'query'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal ['notes', 'list', 'query'], system_calls[0]
    end
  end

  def test_accounts_calls_notes_accounts
    cli = GTD::Notes::CLI.new(['accounts'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal ['notes', 'accounts'], system_calls[0]
    end
  end

  def test_someday_filters_for_somedaymaybe_tag
    cli = GTD::Notes::CLI.new(['someday'])

    note_list = "Note 1\nNote 2\nNote 3"
    note_contents = {
      "'Note 1'" => 'Content without tag',
      "'Note 2'" => 'Content with #somedaymaybe tag',
      "'Note 3'" => 'More content'
    }

    cli.stub :`, ->(cmd) do
      if cmd == 'notes list'
        note_list
      elsif cmd.include?('notes cat')
        note_name = cmd[/notes cat (.+?) 2>/, 1]
        note_contents[note_name] || ''
      else
        ''
      end
    end do
      output = capture_io { cli.run }.first

      assert_match /Note 2/, output
      refute_match /Note 1/, output
      refute_match /Note 3/, output
    end
  end

  def test_reference_calls_notes_list
    cli = GTD::Notes::CLI.new(['reference'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal ['notes', 'list'], system_calls[0]
    end
  end

  def test_l_is_alias_for_list
    cli = GTD::Notes::CLI.new(['l'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal 'notes', system_calls[0][0]
      assert_equal 'list', system_calls[0][1]
    end
  end

  def test_s_is_alias_for_search
    cli = GTD::Notes::CLI.new(['s', 'query'])

    system_calls = []
    cli.stub :system, ->(*args) { system_calls << args; true } do
      cli.run

      assert_equal ['notes', 'list', 'query'], system_calls[0]
    end
  end

  def test_unknown_command_raises_error
    cli = GTD::Notes::CLI.new(['unknown'])
    error = assert_raises(GTD::Notes::UnknownCommand) { cli.run }
    assert_equal 'unknown', error.message
  end
end
