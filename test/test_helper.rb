# frozen_string_literal: true

require "minitest/autorun"
require "webmock/minitest"
require "stringio"

require_relative "../lib/gtd"

module LLMMockHelper
  def stub_llm_command(output:, success: true)
    status = Minitest::Mock.new
    status.expect(:success?, success)

    Open3.stub(:capture3, [output, "", status]) do
      yield
    end
  end

  def with_stdin(input)
    original_stdin = $stdin
    $stdin = StringIO.new(input)
    yield
  ensure
    $stdin = original_stdin
  end

  def capture_output
    original_stdout = $stdout
    original_stderr = $stderr
    $stdout = StringIO.new
    $stderr = StringIO.new
    exit_status = nil
    begin
      yield
    rescue SystemExit => e
      exit_status = e.status
    end
    [$stdout.string, $stderr.string, exit_status]
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  def run_cli_with_input(cli, input:, llm_output:, args: [])
    stdout = nil
    stub_llm_command(output: llm_output) do
      with_stdin(input) do
        stdout, _, _ = capture_output do
          cli.run(args)
        end
      end
    end
    stdout
  end

  def run_cli(cli, args: [])
    stdout, _, _ = capture_output do
      cli.run(args)
    end
    stdout
  end
end

module TodoistMockHelper
  TODOIST_API_BASE = "https://api.todoist.com/rest/v2"

  def stub_todoist_tasks(tasks)
    stub_request(:get, "#{TODOIST_API_BASE}/tasks")
      .to_return(
        status: 200,
        body: tasks.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def stub_todoist_tasks_by_project(project_id, tasks)
    stub_request(:get, "#{TODOIST_API_BASE}/tasks")
      .with(query: { project_id: project_id })
      .to_return(
        status: 200,
        body: tasks.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def stub_todoist_projects(projects)
    stub_request(:get, "#{TODOIST_API_BASE}/projects")
      .to_return(
        status: 200,
        body: projects.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

class Minitest::Test
  include LLMMockHelper
  include TodoistMockHelper

  def setup
    ENV["TODOIST_API_TOKEN"] = "test-token"
  end
end
