require 'test_helper'
require_relative '../../../../lib/gtd/read_review/cli'

class GTD::ReadReview::CLITest < Minitest::Test
  def test_help_displays_usage_by_default
    cli = GTD::ReadReview::CLI.new([])
    output = capture_io { cli.run }.first
    assert_match /gtd-read-review - Save URLs to read-later service/, output
    assert_match /Commands:/, output
  end

  def test_help_command_displays_usage
    cli = GTD::ReadReview::CLI.new(['help'])
    output = capture_io { cli.run }.first
    assert_match /gtd-read-review - Save URLs to read-later service/, output
  end

  def test_add_requires_url
    cli = GTD::ReadReview::CLI.new(['add'])
    assert_raises(GTD::ReadReview::MissingURL) { cli.run }
  end

  def test_add_url_opens_matter_and_outputs_confirmation
    url = 'https://example.com/article'
    cli = GTD::ReadReview::CLI.new(['add', url])

    system_calls = []
    cli.stub :system, ->(cmd, url_arg) { system_calls << [cmd, url_arg]; true } do
      output = capture_io { cli.run }.first

      assert_equal 1, system_calls.size
      assert_equal 'open', system_calls[0][0]
      assert_match %r{https://web.getmatter.com/save\?url=}, system_calls[0][1]
      assert_match /Saved to Matter:/, output
      assert_match /example\.com/, output
    end
  end

  def test_add_encodes_url_parameters
    url = 'https://example.com/article?foo=bar&baz=qux'
    cli = GTD::ReadReview::CLI.new(['add', url])

    system_calls = []
    cli.stub :system, ->(cmd, url_arg) { system_calls << [cmd, url_arg]; true } do
      cli.run

      assert_match /%3F/, system_calls[0][1]  # ? encoded
      assert_match /%26/, system_calls[0][1]  # & encoded
      assert_match /%3D/, system_calls[0][1]  # = encoded
    end
  end

  def test_save_is_alias_for_add
    cli = GTD::ReadReview::CLI.new(['save', 'https://example.com'])

    cli.stub :system, ->(*) { true } do
      output = capture_io { cli.run }.first
      assert_match /Saved to Matter:/, output
    end
  end

  def test_unknown_command_raises_error
    cli = GTD::ReadReview::CLI.new(['unknown'])
    error = assert_raises(GTD::ReadReview::UnknownCommand) { cli.run }
    assert_equal 'unknown', error.message
  end
end
