# frozen_string_literal: true

require_relative "test_helper"

class SuggestContextTest < Minitest::Test
  def test_valid_contexts_defined
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@quick"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@home"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@errand"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@anywhere"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@calls"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@high_energy"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@low_energy"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@va"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@fun"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@ai"
    assert_includes GTD::CLI::SuggestContext::VALID_CONTEXTS, "@thinking"
  end

  def test_system_prompt_includes_context_definitions
    cli = GTD::CLI::SuggestContext.new
    prompt = cli.send(:system_prompt)

    assert_includes prompt, "@quick"
    assert_includes prompt, "@home"
    assert_includes prompt, "GTD"
  end

  def test_validate_contexts_filters_invalid
    cli = GTD::CLI::SuggestContext.new

    result = cli.send(:validate_contexts, "@quick @invalid @home @fake")

    assert_equal ["@quick", "@home"], result
  end

  def test_validate_contexts_handles_empty_string
    cli = GTD::CLI::SuggestContext.new

    result = cli.send(:validate_contexts, "no contexts here")

    assert_equal [], result
  end

  def test_validate_contexts_extracts_all_valid
    cli = GTD::CLI::SuggestContext.new

    result = cli.send(:validate_contexts, "@quick @calls @anywhere")

    assert_equal ["@quick", "@calls", "@anywhere"], result
  end

  def test_build_result_validates_contexts
    cli = GTD::CLI::SuggestContext.new

    result = cli.send(:build_result, 0, "Call mom", "@calls @quick @invalid")

    assert_equal 0, result[:index]
    assert_equal "Call mom", result[:original]
    assert_equal ["@calls", "@quick"], result[:result]
  end

  def test_format_result_joins_contexts
    cli = GTD::CLI::SuggestContext.new

    result = { index: 0, original: "Call mom", result: ["@calls", "@quick"] }
    output = cli.send(:format_result, result, 1)

    assert_includes output, "Call mom"
    assert_includes output, "@calls @quick"
  end

  def test_run_processes_task_and_suggests_contexts
    stdout = run_cli_with_input(
      GTD::CLI::SuggestContext.new,
      input: "Call dentist to schedule cleaning\n",
      llm_output: "1. @calls @quick @anywhere"
    )

    assert_includes stdout, "Call dentist to schedule cleaning"
    assert_includes stdout, "@calls"
    assert_includes stdout, "@quick"
    assert_includes stdout, "@anywhere"
  end

  def test_run_filters_invalid_contexts_from_output
    stdout = run_cli_with_input(
      GTD::CLI::SuggestContext.new,
      input: "Call mom\n",
      llm_output: "1. @calls @invalid_context @quick"
    )

    assert_includes stdout, "@calls"
    assert_includes stdout, "@quick"
    refute_includes stdout, "@invalid_context"
  end

  def test_description_mentions_valid_contexts
    cli = GTD::CLI::SuggestContext.new
    description = cli.send(:description)

    assert_includes description, "@quick"
    assert_includes description, "GTD"
  end

  def test_usage_examples_provided
    cli = GTD::CLI::SuggestContext.new
    examples = cli.send(:usage_examples)

    assert examples.any? { |e| e.include?("suggest-context") }
  end
end
