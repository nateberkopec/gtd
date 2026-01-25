require 'test_helper'

class GtdRemindersIntegrationTest < Minitest::Test
  def setup
    @tool_path = File.join(project_root, 'tools', 'gtd-reminders')
  end

  def test_help_displays_usage
    output = `ruby #{@tool_path} help`
    assert $?.success?
    assert_match /gtd-reminders - Reminders.app CLI wrapper/, output
    assert_match /Commands:/, output
    assert_match /tickler file/, output
  end

  def test_no_command_displays_help
    output = `ruby #{@tool_path}`
    assert $?.success?
    assert_match /gtd-reminders - Reminders.app CLI wrapper/, output
  end

  def test_unknown_command_shows_error
    output = `ruby #{@tool_path} badcmd 2>&1`
    refute $?.success?
    assert_match /Unknown command: badcmd/, output
    assert_match /Run 'gtd-reminders help' for usage/, output
  end

  def test_help_flag_variations
    ['-h', '--help'].each do |flag|
      output = `ruby #{@tool_path} #{flag}`
      assert $?.success?, "#{flag} should succeed"
      assert_match /gtd-reminders - Reminders.app CLI wrapper/, output
    end
  end

  def test_command_aliases
    # Test that aliases are recognized (they'll fail without remindctl, but shouldn't give "unknown command")
    %w[l c d].each do |alias_cmd|
      output = `ruby #{@tool_path} #{alias_cmd} 2>&1`
      refute_match /Unknown command/, output, "Alias '#{alias_cmd}' should be recognized"
    end
  end
end
