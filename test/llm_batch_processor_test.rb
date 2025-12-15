# frozen_string_literal: true

require_relative "test_helper"

class TestProcessor < GTD::CLI::LLMBatchProcessor
  def system_prompt
    "Test prompt"
  end

  def description
    "Test description"
  end

  def usage_examples
    ["echo 'test' | test-processor"]
  end
end

class LLMBatchProcessorTest < Minitest::Test
  def test_default_options
    processor = TestProcessor.new

    assert_equal 10, processor.options[:batch_size]
    assert_equal false, processor.options[:verbose]
    assert_nil processor.options[:model]
  end

  def test_parse_options_verbose
    processor = TestProcessor.new

    capture_output do
      processor.send(:parse_options, ["-v"])
    end

    assert processor.options[:verbose]
  end

  def test_parse_options_batch_size
    processor = TestProcessor.new

    capture_output do
      processor.send(:parse_options, ["-b", "5"])
    end

    assert_equal 5, processor.options[:batch_size]
  end

  def test_parse_options_model
    processor = TestProcessor.new

    capture_output do
      processor.send(:parse_options, ["-m", "gpt-4"])
    end

    assert_equal "gpt-4", processor.options[:model]
  end

  def test_parse_results_numbered_list
    processor = TestProcessor.new

    result_text = <<~TEXT
      1. First result
      2. Second result
      3. Third result
    TEXT

    results = processor.send(:parse_results, result_text)

    assert_equal ["First result", "Second result", "Third result"], results
  end

  def test_parse_results_with_multiline_entries
    processor = TestProcessor.new

    result_text = <<~TEXT
      1. First result
      with continuation
      2. Second result
    TEXT

    results = processor.send(:parse_results, result_text)

    assert_equal ["First result with continuation", "Second result"], results
  end

  def test_parse_results_with_period_numbering
    processor = TestProcessor.new

    result_text = <<~TEXT
      1. First result
      2. Second result
    TEXT

    results = processor.send(:parse_results, result_text)

    assert_equal ["First result", "Second result"], results
  end

  def test_parse_results_with_parenthesis_numbering
    processor = TestProcessor.new

    result_text = <<~TEXT
      1) First result
      2) Second result
    TEXT

    results = processor.send(:parse_results, result_text)

    assert_equal ["First result", "Second result"], results
  end

  def test_process_batch_calls_llm
    processor = TestProcessor.new

    llm_output = "1. Result one\n2. Result two"

    stub_llm_command(output: llm_output) do
      result = processor.send(:process_batch, ["Task one", "Task two"])
      assert_equal llm_output, result
    end
  end

  def test_process_batch_with_model_option
    processor = TestProcessor.new
    processor.options[:model] = "claude-3"

    captured_cmd = nil

    Open3.stub(:capture3, ->(*args, **kwargs) {
      captured_cmd = args
      status = Minitest::Mock.new
      status.expect(:success?, true)
      ["output", "", status]
    }) do
      processor.send(:process_batch, ["Task"])
    end

    assert_includes captured_cmd, "-m"
    assert_includes captured_cmd, "claude-3"
  end

  def test_process_batch_returns_nil_on_failure
    processor = TestProcessor.new

    result = nil
    stub_llm_command(output: "", success: false) do
      _, stderr, _ = capture_output do
        result = processor.send(:process_batch, ["Task"])
      end
      assert_includes stderr, "LLM command failed"
    end

    assert_nil result
  end

  def test_run_processes_stdin_tasks
    stdout = run_cli_with_input(
      TestProcessor.new,
      input: "Test task\n",
      llm_output: "1. Processed task"
    )

    assert_includes stdout, "Test task"
    assert_includes stdout, "Processed task"
  end

  def test_run_with_multiple_tasks
    stdout = run_cli_with_input(
      TestProcessor.new,
      input: "First task\nSecond task\n",
      llm_output: "1. First processed\n2. Second processed"
    )

    assert_includes stdout, "First task"
    assert_includes stdout, "First processed"
    assert_includes stdout, "Second task"
    assert_includes stdout, "Second processed"
  end

  def test_build_result_default
    processor = TestProcessor.new

    result = processor.send(:build_result, 0, "original", "processed")

    assert_equal({ index: 0, original: "original", result: "processed" }, result)
  end
end
