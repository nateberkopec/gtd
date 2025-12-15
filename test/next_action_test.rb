# frozen_string_literal: true

require_relative "test_helper"

class NextActionTest < Minitest::Test
  def test_system_prompt_includes_gtd_methodology
    cli = GTD::CLI::NextAction.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "GTD"
    assert_includes prompt, "next action"
  end

  def test_system_prompt_includes_examples
    cli = GTD::CLI::NextAction.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "Vague:"
    assert_includes prompt, "Reworded:"
  end

  def test_system_prompt_mentions_do_it_now
    cli = GTD::CLI::NextAction.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "DO IT NOW"
    assert_includes prompt, "2 minutes"
  end

  def test_description
    cli = GTD::CLI::NextAction.new
    description = cli.send(:description)

    assert_includes description, "next action"
    assert_includes description, "LLM"
  end

  def test_usage_examples_provided
    cli = GTD::CLI::NextAction.new
    examples = cli.send(:usage_examples)

    assert examples.any? { |e| e.include?("next-action") }
  end

  def test_run_rewrites_vague_task
    stdout = run_cli_with_input(
      GTD::CLI::NextAction.new,
      input: "Dentist appointment\n",
      llm_output: "1. Email dentist office at dentist@example.com to schedule cleaning appointment"
    )

    assert_includes stdout, "Dentist appointment"
    assert_includes stdout, "Email dentist"
  end

  def test_run_handles_do_it_now_response
    stdout = run_cli_with_input(
      GTD::CLI::NextAction.new,
      input: "Reply to quick email\n",
      llm_output: "1. DO IT NOW"
    )

    assert_includes stdout, "Reply to quick email"
    assert_includes stdout, "DO IT NOW"
  end

  def test_run_handles_na_response
    stdout = run_cli_with_input(
      GTD::CLI::NextAction.new,
      input: "Call Bob at 555-1234 about the contract\n",
      llm_output: "1. N/A"
    )

    assert_includes stdout, "Call Bob"
    assert_includes stdout, "N/A"
  end

  def test_run_processes_multiple_tasks
    stdout = run_cli_with_input(
      GTD::CLI::NextAction.new,
      input: "Project update\nQuick reply\n",
      llm_output: "1. Draft email to team about project status update\n2. DO IT NOW"
    )

    assert_includes stdout, "Project update"
    assert_includes stdout, "Draft email"
    assert_includes stdout, "Quick reply"
    assert_includes stdout, "DO IT NOW"
  end
end
