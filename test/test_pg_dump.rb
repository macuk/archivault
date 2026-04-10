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
      mock.expect(:call, nil, ["pg_dump", "-Fc", "-f", @backup_path, @database_url])

      pg_dump = PgDump.new(database_url: @database_url, backup_path: @backup_path)
      Execute.stub(:new, ->(*) { mock }) { pg_dump.call }
      mock.verify
    end
  end
end
