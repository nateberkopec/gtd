require 'test_helper'
require_relative '../../../../lib/gtd/email/cli'

class GTD::Email::CLITest < Minitest::Test
  def test_help_displays_usage_by_default
    cli = GTD::Email::CLI.new([])
    output = capture_io { cli.run }.first
    assert_match /gtd-email - Email CLI wrapper/, output
    assert_match /Commands:/, output
  end

  def test_help_command_displays_usage
    cli = GTD::Email::CLI.new(['help'])
    output = capture_io { cli.run }.first
    assert_match /gtd-email - Email CLI wrapper/, output
  end

  def test_read_requires_id
    cli = GTD::Email::CLI.new(['read'])
    assert_raises(GTD::Email::MissingArgument) { cli.run }
  end

  def test_archive_requires_id
    cli = GTD::Email::CLI.new(['archive'])
    assert_raises(GTD::Email::MissingArgument) { cli.run }
  end

  def test_delete_requires_id
    cli = GTD::Email::CLI.new(['delete'])
    assert_raises(GTD::Email::MissingArgument) { cli.run }
  end

  def test_move_requires_id_and_folder
    cli = GTD::Email::CLI.new(['move'])
    assert_raises(GTD::Email::MissingArgument) { cli.run }

    cli_one_arg = GTD::Email::CLI.new(['move', '123'])
    assert_raises(GTD::Email::MissingArgument) { cli_one_arg.run }
  end

  def test_search_requires_query
    cli = GTD::Email::CLI.new(['search'])
    assert_raises(GTD::Email::MissingArgument) { cli.run }
  end

  def test_unknown_command_raises_error
    cli = GTD::Email::CLI.new(['unknown'])
    error = assert_raises(GTD::Email::UnknownCommand) { cli.run }
    assert_equal 'unknown', error.message
  end
end
