require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

module TestHelpers
  def project_root
    File.expand_path('..', __dir__)
  end

  def fixture_path(name)
    File.join(project_root, 'test', 'fixtures', name)
  end

  def stub_command(command, output: '', exit_status: 0)
    mock_result = Minitest::Mock.new
    mock_result.expect(:success?, exit_status.zero?)

    Object.stub_const(:COMMAND_STUBS, {}) unless Object.const_defined?(:COMMAND_STUBS)
    COMMAND_STUBS[command] = { output: output, status: mock_result }
  end

  def with_test_mode
    original_mode = ENV['TEST_MODE']
    ENV['TEST_MODE'] = '1'
    yield
  ensure
    ENV['TEST_MODE'] = original_mode
  end

  def stub_fixture(fixture_name, content)
    fixtures_dir = File.join(project_root, 'test', 'fixtures')
    FileUtils.mkdir_p(fixtures_dir)
    File.write(File.join(fixtures_dir, fixture_name), content)
  end
end

class Minitest::Test
  include TestHelpers
end
