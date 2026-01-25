require 'test_helper'

class GtdNotesIntegrationTest < Minitest::Test
  def setup
    @tool_path = File.join(project_root, 'tools', 'gtd-notes')
  end

  def test_help_displays_usage
    output = `ruby #{@tool_path} help`
    assert $?.success?
    assert_match /gtd-notes - Apple Notes/, output
    assert_match /Commands:/, output
  end

  def test_no_command_displays_help
    output = `ruby #{@tool_path}`
    assert $?.success?
    assert_match /gtd-notes - Apple Notes/, output
  end

  def test_unknown_command_shows_error
    output = `ruby #{@tool_path} badcmd 2>&1`
    refute $?.success?
    assert_match /Unknown command: badcmd/, output
    assert_match /Run 'gtd-notes help' for usage/, output
  end

  def test_help_flag_displays_usage
    output = `ruby #{@tool_path} --help`
    assert $?.success?
    assert_match /gtd-notes - Apple Notes/, output
  end

  def test_h_flag_displays_usage
    output = `ruby #{@tool_path} -h`
    assert $?.success?
    assert_match /gtd-notes - Apple Notes/, output
  end
end
