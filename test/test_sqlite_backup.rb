# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestSqliteBackup < Minitest::Test
    def setup
      @database_path = "/tmp/db.sqlite3"
      @backup_path = "/tmp/backup.sqlite3"
      @sqlite_command = %(.backup "#{@backup_path}")
    end

    def test_call
      mock = Minitest::Mock.new
      mock.expect(:call, nil, ["sqlite3", @database_path, @sqlite_command])

      sqlite_backup = SqliteBackup.new(database_path: @database_path, backup_path: @backup_path)
      Execute.stub(:new, ->(*) { mock }) { sqlite_backup.call }
      mock.verify
    end
  end
end
