# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestSqlite < Minitest::Test
    def setup
      @database_path = "/tmp/db.sqlite3"
      @backup_path = "/tmp/backup.sqlite3"
      @sqlite_command = %(.backup "#{@backup_path}")
    end

    def test_initialize_raises_when_database_path_is_nil
      error = assert_raises(ArgumentError) { Sqlite.new(database_path: nil, backup_path: @backup_path) }

      assert_equal("database_path is required", error.message)
    end

    def test_initialize_raises_when_database_path_is_empty
      error = assert_raises(ArgumentError) { Sqlite.new(database_path: "", backup_path: @backup_path) }

      assert_equal("database_path is required", error.message)
    end

    def test_initialize_raises_when_backup_path_is_nil
      error = assert_raises(ArgumentError) { Sqlite.new(database_path: @database_path, backup_path: nil) }

      assert_equal("backup_path is required", error.message)
    end

    def test_initialize_raises_when_backup_path_is_empty
      error = assert_raises(ArgumentError) { Sqlite.new(database_path: @database_path, backup_path: "") }

      assert_equal("backup_path is required", error.message)
    end

    def test_call
      mock = Minitest::Mock.new
      mock.expect(:call, nil, ["sqlite3", @database_path, @sqlite_command])

      sqlite_backup = Sqlite.new(database_path: @database_path, backup_path: @backup_path)
      Execute.stub(:new, ->(*) { mock }) { sqlite_backup.call }
      mock.verify
    end
  end
end
