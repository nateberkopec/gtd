require 'httparty'
require 'json'
require_relative 'config'

module GTD
  class TodoistClient
    include HTTParty
    base_uri Config.todoist_api_url

    def initialize
      @headers = {
        'Authorization' => "Bearer #{Config.todoist_api_token}",
        'Content-Type' => 'application/json'
      }
    end

    # Get all active tasks
    def get_tasks
      response = self.class.get('/tasks', headers: @headers)
      handle_response(response)
    end

    # Get tasks for a specific project
    def get_tasks_by_project(project_name)
      # First, find the project ID
      project = find_project_by_name(project_name)
      return [] unless project

      # Then get tasks for that project
      response = self.class.get("/tasks", headers: @headers, query: { project_id: project['id'] })
      handle_response(response)
    end

    # Get all projects
    def get_projects
      response = self.class.get('/projects', headers: @headers)
      handle_response(response)
    end

    private

    def handle_response(response)
      return JSON.parse(response.body) if response.success?

      log_error(response)
      []
    end

    def log_error(response)
      STDERR.puts "Error: #{response.code} - #{response.message}"
      STDERR.puts response.body if response.body
    end

    def find_project_by_name(name)
      projects = get_projects
      projects.find { |project| project['name'].downcase == name.downcase }
    end
  end
end
