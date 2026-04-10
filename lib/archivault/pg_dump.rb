# frozen_string_literal: true

# To restore a database from a dump file, use:
# pg_restore --no-owner -d DATABASE_URL database.dump
module Archivault
  class PgDump
    def initialize(database_url:, backup_path:)
      raise ArgumentError, "database_path is required" if database_url.nil? || database_url.to_s.empty?
      raise ArgumentError, "backup_path is required" if backup_path.nil? || backup_path.to_s.empty?

      @database_url = database_url.to_s
      @backup_path = backup_path.to_s
    end

    def call
      Execute.new.call("pg_dump", "-Fc", "-f", @backup_path, @database_url)
    end
  end
end
