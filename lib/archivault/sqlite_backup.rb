# frozen_string_literal: true

module Archivault
  class SqliteBackup
    def initialize(database_path:, passphrase:)
      @database_path = database_path.to_s
      @passphrase = passphrase.to_s
      @timestamp = Timestamp.new.timestamp
      @tmp_path = Tmp.new.path
      @backup_path = "#{@tmp_path}/database-#{@timestamp}.sqlite3"
      @tar_path = "#{@tmp_path}/database-#{@timestamp}.tgz"
      @gpg_path = "#{@tar_path}.gpg"
    end

    def call
      Sqlite.new(database_path: @database_path, backup_path: @backup_path).call
      Tar.new(tar_path: @tar_path, path_or_paths: @backup_path).call
      Gpg.new(@tar_path).call(@passphrase)
    ensure
      Clean.new([@backup_path, @tar_path]).call
    end
  end
end
