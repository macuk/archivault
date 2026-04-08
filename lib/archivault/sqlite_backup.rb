# frozen_string_literal: true

module Archivault
  class SqliteBackup
    def initialize(database_path:, backup_path:)
      @database_path = database_path.to_s
      @backup_path = backup_path.to_s
    end

    def call
      Execute.new.call("sqlite3", @database_path, %(.backup "#{@backup_path}"))
    end
  end
end
