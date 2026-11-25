# frozen_string_literal: true

require "test_helper"
require "rbconfig"
require "tempfile"

module Archivault
  class TestExecute < Minitest::Test
    def test_happy_path
      assert Execute.new.call("true")
    end

    def test_nil_status
      command = File.join(__dir__, "nonexistent-command")
      error = assert_raises(ExecuteError) do
        Execute.new.call(command, env: { "PGPASSWORD" => "secret" })
      end

      assert_equal "#{command} could not be executed", error.message
    end

    def test_false_status
      error = assert_raises(ExecuteError) do
        Execute.new.call(RbConfig.ruby, "-e", "exit(7)", env: { "PGPASSWORD" => "secret" })
      end

      assert_equal "#{RbConfig.ruby} failed with exit code 7", error.message
    end

    def test_environment_is_passed_without_changing_parent_environment
      original_env = ENV.to_h

      assert Execute.new.call(
        RbConfig.ruby, "-e", 'exit(ENV.fetch("ARCHIVAULT_TEST_VALUE") == ARGV.first ? 0 : 1)',
        "dynamic value", env: { "ARCHIVAULT_TEST_VALUE" => "dynamic value" }
      )
      assert_equal original_env, ENV.to_h
    end

    def test_system_options_are_passed_with_environment
      Tempfile.create("archivault-execute") do |output|
        assert Execute.new.call(
          RbConfig.ruby, "-e", 'puts ENV.fetch("ARCHIVAULT_TEST_VALUE"); warn "error output"',
          env: { "ARCHIVAULT_TEST_VALUE" => "dynamic value" }, out: output, err: File::NULL
        )
        output.rewind

        assert_equal "dynamic value\n", output.read
      end
    end
  end
end
