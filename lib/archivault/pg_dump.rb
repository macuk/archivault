# frozen_string_literal: true

# To restore a database from a dump file, use:
# pg_restore --clean --if-exists --no-owner --no-acl --role=db-role -U postgres -d db-name /tmp/db.dump
module Archivault
  class PgDump
    def initialize(database_url:, backup_path:)
      raise ArgumentError, "database_path is required" if database_url.nil? || database_url.to_s.empty?
      raise ArgumentError, "backup_path is required" if backup_path.nil? || backup_path.to_s.empty?

      @database_url = database_url.to_s
      @backup_path = backup_path.to_s
    end

    # The password goes to pg_dump through PGPASSWORD, not through the command line:
    # arguments of a running process are readable by every local user (ps, /proc/<pid>/cmdline).
    def call
      uri = parse_database_url
      password = URI.decode_uri_component(uri.password) if uri.password && !uri.password.empty?
      uri.password = nil
      env = password ? { "PGPASSWORD" => password } : {}
      Execute.new.call("pg_dump", "-Fc", "-f", @backup_path, uri.to_s, env: env)
    end

    private

    def parse_database_url
      URI.parse(@database_url)
    rescue URI::InvalidURIError
      # URI::InvalidURIError quotes the whole input, password included - re-raise without it.
      raise "Invalid database URL: percent-encode special characters in the password", cause: nil
    end
  end
end
