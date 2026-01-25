require 'test_helper'
require_relative '../../../../lib/gtd/action/api_client'
require 'json'
require 'tempfile'

class GTD::Action::ApiClientTest < Minitest::Test
  def setup
    @temp_config = Tempfile.new(['todoist_config', '.json'])
    @temp_config.write({ token: 'test_token_123' }.to_json)
    @temp_config.close

    @client = GTD::Action::ApiClient.new
    @client.config_path = @temp_config.path
    @client.instance_variable_set(:@token, @client.send(:load_token))
  end

  def teardown
    @temp_config.unlink
  end

  def test_loads_token_from_config
    assert_equal 'test_token_123', @client.instance_variable_get(:@token)
  end

  def test_task_url_format
    url = @client.task_url('12345')
    assert_equal 'https://todoist.com/showTask?id=12345', url
  end

  def test_project_url_format
    url = @client.project_url('67890')
    assert_equal 'https://todoist.com/showProject?id=67890', url
  end

  def test_lookup_project_id_returns_id_when_found
    projects_response = [
      { 'id' => '111', 'name' => 'Work' },
      { 'id' => '222', 'name' => 'Personal' }
    ]

    @client.stub :get, projects_response do
      result = @client.lookup_project_id('Work')
      assert_equal '111', result
    end
  end

  def test_lookup_project_id_returns_nil_when_not_found
    projects_response = [
      { 'id' => '111', 'name' => 'Work' }
    ]

    @client.stub :get, projects_response do
      result = @client.lookup_project_id('NonExistent')
      assert_nil result
    end
  end

  def test_lookup_section_id_returns_id_when_found
    projects_response = [{ 'id' => '111', 'name' => 'Work' }]
    sections_response = [
      { 'id' => '555', 'name' => 'Active' },
      { 'id' => '666', 'name' => 'Waiting' }
    ]

    call_count = 0
    @client.stub :get, ->(path) {
      call_count += 1
      call_count == 1 ? projects_response : sections_response
    } do
      result = @client.lookup_section_id('Work', 'Active')
      assert_equal '555', result
    end
  end

  def test_lookup_section_id_returns_nil_when_project_not_found
    projects_response = []

    @client.stub :get, projects_response do
      result = @client.lookup_section_id('NonExistent', 'Active')
      assert_nil result
    end
  end

  def test_lookup_section_id_returns_nil_when_section_not_found
    projects_response = [{ 'id' => '111', 'name' => 'Work' }]
    sections_response = []

    call_count = 0
    @client.stub :get, ->(path) {
      call_count += 1
      call_count == 1 ? projects_response : sections_response
    } do
      result = @client.lookup_section_id('Work', 'NonExistent')
      assert_nil result
    end
  end

  def test_raises_error_when_config_missing
    client = GTD::Action::ApiClient.new
    client.config_path = '/nonexistent/path'

    error = assert_raises(GTD::Action::ApiClient::ApiError) do
      client.send(:load_token)
    end
    assert_match /Failed to load Todoist token/, error.message
  end
end
