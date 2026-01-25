require 'test_helper'
require_relative '../../../../lib/gtd/action/cli'

class GTD::Action::CLITest < Minitest::Test
  def setup
    @api_mock = Minitest::Mock.new
  end

  def test_help_displays_usage_by_default
    cli = GTD::Action::CLI.new([])
    output = capture_io { cli.run }.first
    assert_match /gtd-action - Todoist CLI wrapper/, output
    assert_match /Commands:/, output
  end

  def test_help_command_displays_usage
    cli = GTD::Action::CLI.new(['help'])
    output = capture_io { cli.run }.first
    assert_match /gtd-action - Todoist CLI wrapper/, output
  end

  def test_unknown_command_raises_error
    cli = GTD::Action::CLI.new(['unknown'])
    error = assert_raises(GTD::Action::UnknownCommand) { cli.run }
    assert_equal 'unknown', error.message
  end

  def test_add_requires_text
    cli = GTD::Action::CLI.new(['add'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /--text required/, error.message
    end
  end

  def test_add_requires_labels_unless_forced
    cli = GTD::Action::CLI.new(['add', '--text', 'Test task'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /context labels/, error.message
    end
  end

  def test_add_with_force_skips_label_check
    cli = GTD::Action::CLI.new(['add', '--text', 'Test task', '--force'])

    api_mock = Minitest::Mock.new
    api_mock.expect :post, { 'id' => '123' }, ['tasks', Hash]
    api_mock.expect :task_url, 'https://todoist.com/showTask?id=123', ['123']

    cli.stub :sync_todoist, true do
      GTD::Action::ApiClient.stub :new, api_mock do
        cli = GTD::Action::CLI.new(['add', '--text', 'Test task', '--force'])
        output = capture_io { cli.run }.first
        assert_match /123 Test task/, output
      end
    end

    api_mock.verify
  end

  def test_complete_requires_id
    cli = GTD::Action::CLI.new(['complete'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /--id required/, error.message
    end
  end

  def test_delete_requires_id
    cli = GTD::Action::CLI.new(['delete'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /--id required/, error.message
    end
  end

  def test_modify_requires_id
    cli = GTD::Action::CLI.new(['modify', '--text', 'New text'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /--id required/, error.message
    end
  end

  def test_modify_requires_changes
    cli = GTD::Action::CLI.new(['modify', '--id', '123'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /no changes specified/, error.message
    end
  end

  def test_project_add_requires_name
    cli = GTD::Action::CLI.new(['project-add'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /--name required/, error.message
    end
  end

  def test_section_list_requires_project
    cli = GTD::Action::CLI.new(['section-list'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /--project required/, error.message
    end
  end

  def test_label_add_requires_name
    cli = GTD::Action::CLI.new(['label-add'])
    cli.stub :sync_todoist, true do
      error = assert_raises(ArgumentError) { cli.run }
      assert_match /--name required/, error.message
    end
  end

  def test_parse_flags_correctly
    cli = GTD::Action::CLI.new([
      'add',
      '--text', 'Test task',
      '--priority', '3',
      '--date', 'tomorrow',
      '--project', 'Work',
      '--section', 'Active',
      '--labels', 'office,computer',
      '--force'
    ])

    assert_equal 'add', cli.instance_variable_get(:@command)
    options = cli.instance_variable_get(:@options)
    assert_equal 'Test task', options[:text]
    assert_equal 3, options[:priority]
    assert_equal 'tomorrow', options[:date]
    assert_equal 'Work', options[:project]
    assert_equal 'Active', options[:section]
    assert_equal 'office,computer', options[:labels]
    assert_equal true, options[:force]
  end

  def test_short_flags_work
    cli = GTD::Action::CLI.new([
      'add',
      '-t', 'Test',
      '-p', '2',
      '-d', 'today',
      '-P', 'Project',
      '-S', 'Section',
      '-l', 'label'
    ])

    options = cli.instance_variable_get(:@options)
    assert_equal 'Test', options[:text]
    assert_equal 2, options[:priority]
    assert_equal 'today', options[:date]
    assert_equal 'Project', options[:project]
    assert_equal 'Section', options[:section]
    assert_equal 'label', options[:labels]
  end
end
