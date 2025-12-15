# frozen_string_literal: true

require_relative "test_helper"

class TodoGetTest < Minitest::Test
  def test_run_fetches_all_tasks
    stub_todoist_tasks([
      {"content" => "Buy groceries", "labels" => []},
      {"content" => "Call mom", "labels" => ["calls"]}
    ])

    stdout = run_cli(GTD::CLI::TodoGet.new)

    assert_includes stdout, "Buy groceries"
    assert_includes stdout, "Call mom"
    assert_includes stdout, "@calls"
  end

  def test_run_fetches_tasks_by_project
    stub_todoist_projects([
      {"id" => "123", "name" => "Work"},
      {"id" => "456", "name" => "Personal"}
    ])
    stub_todoist_tasks_by_project("123", [
      {"content" => "Finish report", "labels" => ["high_energy"]}
    ])

    stdout = run_cli(GTD::CLI::TodoGet.new, args: ["-p", "Work"])

    assert_includes stdout, "Finish report"
    assert_includes stdout, "@high_energy"
  end

  def test_run_handles_empty_tasks
    stub_todoist_tasks([])

    stdout = run_cli(GTD::CLI::TodoGet.new)

    assert_includes stdout, "No tasks found"
  end

  def test_run_handles_empty_project_tasks
    stub_todoist_projects([{"id" => "123", "name" => "Empty"}])
    stub_todoist_tasks_by_project("123", [])

    stdout = run_cli(GTD::CLI::TodoGet.new, args: ["-p", "Empty"])

    assert_includes stdout, "No tasks found"
    assert_includes stdout, "Empty"
  end

  def test_run_handles_project_not_found
    stub_todoist_projects([{"id" => "123", "name" => "Work"}])

    stdout = run_cli(GTD::CLI::TodoGet.new, args: ["-p", "NonExistent"])

    assert_includes stdout, "No tasks found"
  end

  def test_format_task_without_labels
    cli = GTD::CLI::TodoGet.new

    task = {"content" => "Simple task", "labels" => []}
    output = cli.send(:format_task, task)

    assert_equal "Simple task", output
  end

  def test_format_task_with_single_label
    cli = GTD::CLI::TodoGet.new

    task = {"content" => "Call dentist", "labels" => ["calls"]}
    output = cli.send(:format_task, task)

    assert_equal "Call dentist @calls", output
  end

  def test_format_task_with_multiple_labels
    cli = GTD::CLI::TodoGet.new

    task = {"content" => "Quick call", "labels" => ["calls", "quick"]}
    output = cli.send(:format_task, task)

    assert_equal "Quick call @calls @quick", output
  end

  def test_format_task_with_nil_labels
    cli = GTD::CLI::TodoGet.new

    task = {"content" => "No labels key"}
    output = cli.send(:format_task, task)

    assert_equal "No labels key", output
  end

  def test_run_displays_multiple_labels
    stub_todoist_tasks([
      {"content" => "Important call", "labels" => ["calls", "high_energy", "quick"]}
    ])

    stdout = run_cli(GTD::CLI::TodoGet.new)

    assert_includes stdout, "Important call"
    assert_includes stdout, "@calls"
    assert_includes stdout, "@high_energy"
    assert_includes stdout, "@quick"
  end

  def test_run_case_insensitive_project_match
    stub_todoist_projects([{"id" => "123", "name" => "Work Projects"}])
    stub_todoist_tasks_by_project("123", [{"content" => "Task 1", "labels" => []}])

    stdout = run_cli(GTD::CLI::TodoGet.new, args: ["-p", "work projects"])

    assert_includes stdout, "Task 1"
  end

  def test_options_starts_empty
    cli = GTD::CLI::TodoGet.new

    assert_equal({}, cli.options)
  end

  def test_parse_options_sets_project
    cli = GTD::CLI::TodoGet.new

    capture_output do
      cli.send(:parse_options, ["-p", "MyProject"])
    end

    assert_equal "MyProject", cli.options[:project]
  end
end
