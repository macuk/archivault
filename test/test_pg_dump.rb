# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestPgDump < Minitest::Test
    def setup
      @database_url = "postgres://localhost:5432/mydb"
      @backup_path = "/tmp/database.dump"
    end

    def test_initialize_raises_when_database_url_is_nil
      error = assert_raises(ArgumentError) { PgDump.new(database_url: nil, backup_path: @backup_path) }

      assert_equal("database_path is required", error.message)
    end

    def test_initialize_raises_when_database_url_is_empty
      error = assert_raises(ArgumentError) { PgDump.new(database_url: "", backup_path: @backup_path) }

      assert_equal("database_path is required", error.message)
    end

    def test_initialize_raises_when_backup_path_is_nil
      error = assert_raises(ArgumentError) { PgDump.new(database_url: @database_url, backup_path: nil) }

      assert_equal("backup_path is required", error.message)
    end

    def test_initialize_raises_when_backup_path_is_empty
      error = assert_raises(ArgumentError) { PgDump.new(database_url: @database_url, backup_path: "") }

      assert_equal("backup_path is required", error.message)
    end

    def test_call
      mock = Minitest::Mock.new
      mock.expect(:call, nil, ["pg_dump", "-Fc", "-f", @backup_path, @database_url], env: {})

      pg_dump = PgDump.new(database_url: @database_url, backup_path: @backup_path)
      Execute.stub(:new, ->(*) { mock }) { pg_dump.call }
      mock.verify
    end

    def test_call_passes_decoded_password_through_environment
      database_url = "postgres://user:secret%40pass+word%26@localhost:5432/mydb"
      mock = Minitest::Mock.new
      mock.expect(:call, nil, ["pg_dump", "-Fc", "-f", @backup_path, "postgres://user@localhost:5432/mydb"],
                  env: { "PGPASSWORD" => "secret@pass+word&" })

      pg_dump = PgDump.new(database_url: database_url, backup_path: @backup_path)
      Execute.stub(:new, ->(*) { mock }) { pg_dump.call }
      mock.verify
    end

    def test_call_with_empty_password
      mock = Minitest::Mock.new
      mock.expect(:call, nil, ["pg_dump", "-Fc", "-f", @backup_path, "postgres://user@localhost:5432/mydb"], env: {})

      pg_dump = PgDump.new(database_url: "postgres://user:@localhost:5432/mydb", backup_path: @backup_path)
      Execute.stub(:new, ->(*) { mock }) { pg_dump.call }
      mock.verify
    end

    def test_invalid_database_url_does_not_expose_password_in_exception
      password = "top secret"
      pg_dump = PgDump.new(database_url: "postgres://user:#{password}@localhost/mydb", backup_path: @backup_path)

      error = assert_raises(RuntimeError) { pg_dump.call }

      assert_equal "Invalid database URL: percent-encode special characters in the password", error.message
      assert_nil error.cause
      refute_includes error.full_message(highlight: false), password
    end
  end
end
