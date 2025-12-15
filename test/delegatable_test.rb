# frozen_string_literal: true

require_relative "test_helper"

class DelegatableTest < Minitest::Test
  def test_default_options_includes_only_delegatable
    cli = GTD::CLI::Delegatable.new

    assert cli.options[:only_delegatable]
  end

  def test_system_prompt_includes_ea_guidelines
    cli = GTD::CLI::Delegatable.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "Executive Assistant"
    assert_includes prompt, "EA"
    assert_includes prompt, "scheduling"
  end

  def test_system_prompt_includes_ai_guidelines
    cli = GTD::CLI::Delegatable.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "Artificial Intelligence"
    assert_includes prompt, "AI"
    assert_includes prompt, "Data analysis"
  end

  def test_system_prompt_includes_not_delegatable_guidelines
    cli = GTD::CLI::Delegatable.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "NOT Delegatable"
    assert_includes prompt, "Strategic decisions"
  end

  def test_system_prompt_defines_response_format
    cli = GTD::CLI::Delegatable.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "DELEGATE TO EA:"
    assert_includes prompt, "AI TASK:"
    assert_includes prompt, "NOT DELEGATABLE:"
  end

  def test_description
    cli = GTD::CLI::Delegatable.new
    description = cli.send(:description)

    assert_includes description, "delegated"
    assert_includes description, "EA"
    assert_includes description, "AI"
  end

  def test_usage_examples_provided
    cli = GTD::CLI::Delegatable.new
    examples = cli.send(:usage_examples)

    assert examples.any? { |e| e.include?("delegatable") }
  end

  def test_configure_options_adds_all_flag
    cli = GTD::CLI::Delegatable.new

    capture_output do
      cli.send(:parse_options, ["--all"])
    end

    refute cli.options[:only_delegatable]
  end

  def test_filter_results_removes_not_delegatable_by_default
    cli = GTD::CLI::Delegatable.new

    results = [
      { index: 0, original: "Task 1", result: "DELEGATE TO EA: scheduling" },
      { index: 1, original: "Task 2", result: "NOT DELEGATABLE: personal" },
      { index: 2, original: "Task 3", result: "AI TASK: research" }
    ]

    filtered = cli.send(:filter_results, results)

    assert_equal 2, filtered.size
    assert filtered.all? { |r| !r[:result].start_with?("NOT DELEGATABLE") }
  end

  def test_filter_results_keeps_all_with_all_flag
    cli = GTD::CLI::Delegatable.new
    cli.options[:only_delegatable] = false

    results = [
      { index: 0, original: "Task 1", result: "DELEGATE TO EA: scheduling" },
      { index: 1, original: "Task 2", result: "NOT DELEGATABLE: personal" },
      { index: 2, original: "Task 3", result: "AI TASK: research" }
    ]

    filtered = cli.send(:filter_results, results)

    assert_equal 3, filtered.size
  end

  def test_run_shows_delegatable_tasks
    stdout = run_cli_with_input(
      GTD::CLI::Delegatable.new,
      input: "Schedule meeting with Bob\n",
      llm_output: "1. DELEGATE TO EA: This is a scheduling task that can be handled by an assistant"
    )

    assert_includes stdout, "Schedule meeting with Bob"
    assert_includes stdout, "DELEGATE TO EA"
  end

  def test_run_filters_non_delegatable_by_default
    stdout = run_cli_with_input(
      GTD::CLI::Delegatable.new,
      input: "Schedule meeting\nStrategic planning\n",
      llm_output: "1. DELEGATE TO EA: scheduling task\n2. NOT DELEGATABLE: requires personal attention"
    )

    assert_includes stdout, "Schedule meeting"
    assert_includes stdout, "DELEGATE TO EA"
    refute_includes stdout, "Strategic planning"
  end

  def test_run_shows_all_with_all_flag
    stdout = run_cli_with_input(
      GTD::CLI::Delegatable.new,
      input: "Schedule meeting\nStrategic planning\n",
      llm_output: "1. DELEGATE TO EA: scheduling task\n2. NOT DELEGATABLE: requires personal attention",
      args: ["--all"]
    )

    assert_includes stdout, "Schedule meeting"
    assert_includes stdout, "Strategic planning"
    assert_includes stdout, "NOT DELEGATABLE"
  end

  def test_run_shows_ai_tasks
    stdout = run_cli_with_input(
      GTD::CLI::Delegatable.new,
      input: "Research competitor pricing\n",
      llm_output: "1. AI TASK: This research can be done with AI assistance"
    )

    assert_includes stdout, "Research competitor pricing"
    assert_includes stdout, "AI TASK"
  end
end
