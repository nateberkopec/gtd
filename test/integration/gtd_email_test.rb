require 'test_helper'

class GtdEmailIntegrationTest < Minitest::Test
  def setup
    @tool_path = File.join(project_root, 'tools', 'gtd-email')
  end

  def test_help_displays_usage
    output = `ruby #{@tool_path} help`
    assert $?.success?
    assert_match /gtd-email - Email CLI wrapper/, output
    assert_match /Commands:/, output
  end

  def test_no_command_displays_help
    output = `ruby #{@tool_path}`
    assert $?.success?
    assert_match /gtd-email - Email CLI wrapper/, output
  end

  def test_read_without_id_shows_error
    output = `ruby #{@tool_path} read 2>&1`
    refute $?.success?
    assert_match /Error: read requires an email ID/, output
    assert_match /Run 'gtd-email help' for usage/, output
  end

  def test_archive_without_id_shows_error
    output = `ruby #{@tool_path} archive 2>&1`
    refute $?.success?
    assert_match /Error: archive requires an email ID/, output
  end

  def test_delete_without_id_shows_error
    output = `ruby #{@tool_path} delete 2>&1`
    refute $?.success?
    assert_match /Error: delete requires an email ID/, output
  end

  def test_move_without_arguments_shows_error
    output = `ruby #{@tool_path} move 2>&1`
    refute $?.success?
    assert_match /Error: move requires ID and FOLDER/, output
  end

  def test_move_with_only_id_shows_error
    output = `ruby #{@tool_path} move 123 2>&1`
    refute $?.success?
    assert_match /Error: move requires ID and FOLDER/, output
  end

  def test_search_without_query_shows_error
    output = `ruby #{@tool_path} search 2>&1`
    refute $?.success?
    assert_match /Error: search requires a query/, output
  end

  def test_unknown_command_shows_error
    output = `ruby #{@tool_path} badcmd 2>&1`
    refute $?.success?
    assert_match /Unknown command: badcmd/, output
    assert_match /Run 'gtd-email help' for usage/, output
  end
end
