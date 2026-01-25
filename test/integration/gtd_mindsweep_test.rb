require 'test_helper'

class GtdMindsweepIntegrationTest < Minitest::Test
  def setup
    @tool_path = File.join(project_root, 'tools', 'gtd-mindsweep', 'gtd-mindsweep')
  end

  def test_displays_mind_sweep_content
    output = `timeout 2 ruby #{@tool_path} 2>&1 || true`
    assert_includes output, '=== Mind Sweep ==='
    assert_match /Watch the triggers/, output
  end

  def test_fails_if_triggers_file_missing
    skip "This test requires moving the triggers file temporarily"
  end
end
