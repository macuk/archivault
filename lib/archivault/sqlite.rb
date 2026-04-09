# frozen_string_literal: true

module Archivault
  class Sqlite
    def initialize(database_path:, backup_path:)
      raise ArgumentError, "database_path is required" if database_path.nil? || database_path.to_s.empty?
      raise ArgumentError, "backup_path is required" if backup_path.nil? || backup_path.to_s.empty?

      @database_path = database_path.to_s
      @backup_path = backup_path.to_s
    end

    def call
      Execute.new.call("sqlite3", @database_path, %(.backup "#{@backup_path}"))
    end
  end
end
