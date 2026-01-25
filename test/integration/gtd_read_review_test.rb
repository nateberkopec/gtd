require 'test_helper'

class GtdReadReviewIntegrationTest < Minitest::Test
  def setup
    @tool_path = File.join(project_root, 'tools', 'gtd-read-review')
  end

  def test_help_displays_usage
    output = `ruby #{@tool_path} help`
    assert $?.success?
    assert_match /gtd-read-review - Save URLs/, output
    assert_match /Commands:/, output
  end

  def test_no_command_displays_help
    output = `ruby #{@tool_path}`
    assert $?.success?
    assert_match /gtd-read-review - Save URLs/, output
  end

  def test_add_without_url_shows_error
    output = `ruby #{@tool_path} add 2>&1`
    refute $?.success?
    assert_match /Usage: gtd-read-review add URL/, output
  end

  def test_unknown_command_shows_error
    output = `ruby #{@tool_path} badcmd 2>&1`
    refute $?.success?
    assert_match /Unknown command: badcmd/, output
    assert_match /Run 'gtd-read-review help' for usage/, output
  end
end
