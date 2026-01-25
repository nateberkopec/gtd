require 'test_helper'

class GtdActionIntegrationTest < Minitest::Test
  def setup
    @tool_path = File.join(project_root, 'tools', 'gtd-action')
  end

  def test_help_displays_usage
    output = `ruby #{@tool_path} help`
    assert $?.success?
    assert_match /gtd-action - Todoist CLI wrapper/, output
    assert_match /Commands:/, output
    assert_match /Priority conventions:/, output
  end

  def test_no_command_displays_help
    output = `ruby #{@tool_path}`
    assert $?.success?
    assert_match /gtd-action - Todoist CLI wrapper/, output
  end

  def test_unknown_command_shows_error
    output = `ruby #{@tool_path} badcmd 2>&1`
    refute $?.success?
    assert_match /Unknown command: badcmd/, output
    assert_match /Run 'gtd-action help' for usage/, output
  end

  def test_add_without_text_shows_error
    output = `ruby #{@tool_path} add 2>&1`
    refute $?.success?
    assert_match /--text required/, output
  end

  def test_add_without_labels_shows_error
    output = `ruby #{@tool_path} add --text "Test task" 2>&1`
    refute $?.success?
    assert_match /context labels/, output
  end

  def test_complete_without_id_shows_error
    output = `ruby #{@tool_path} complete 2>&1`
    refute $?.success?
    assert_match /--id required/, output
  end

  def test_delete_without_id_shows_error
    output = `ruby #{@tool_path} delete 2>&1`
    refute $?.success?
    assert_match /--id required/, output
  end

  def test_modify_without_id_shows_error
    output = `ruby #{@tool_path} modify --text "New text" 2>&1`
    refute $?.success?
    assert_match /--id required/, output
  end

  def test_modify_without_changes_shows_error
    output = `ruby #{@tool_path} modify --id 123 2>&1`
    refute $?.success?
    assert_match /no changes specified/, output
  end

  def test_project_add_without_name_shows_error
    output = `ruby #{@tool_path} project-add 2>&1`
    refute $?.success?
    assert_match /--name required/, output
  end

  def test_section_list_without_project_shows_error
    output = `ruby #{@tool_path} section-list 2>&1`
    refute $?.success?
    assert_match /--project required/, output
  end

  def test_label_add_without_name_shows_error
    output = `ruby #{@tool_path} label-add 2>&1`
    refute $?.success?
    assert_match /--name required/, output
  end

  def test_help_flag_variations
    ['-h', '--help'].each do |flag|
      output = `ruby #{@tool_path} #{flag}`
      assert $?.success?, "#{flag} should succeed"
      assert_match /gtd-action - Todoist CLI wrapper/, output
    end
  end

  def test_command_aliases
    # Test that aliases are recognized (they'll fail without proper setup, but shouldn't give "unknown command")
    %w[l a c m].each do |alias_cmd|
      output = `ruby #{@tool_path} #{alias_cmd} 2>&1`
      refute_match /Unknown command/, output, "Alias '#{alias_cmd}' should be recognized"
    end
  end
end
