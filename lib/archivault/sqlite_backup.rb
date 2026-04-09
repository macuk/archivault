# frozen_string_literal: true

module Archivault
  class SqliteBackup
    def initialize(database_path:, gpg_passphrase:, s3_setup:)
      raise ArgumentError, "database_path is required" if database_path.nil? || database_path.to_s.empty?
      raise ArgumentError, "gpg_passphrase is required" if gpg_passphrase.nil? || gpg_passphrase.to_s.empty?

      @database_path = database_path.to_s
      @gpg_passphrase = gpg_passphrase.to_s
      @s3_setup = s3_setup

      @timestamp = Timestamp.new.timestamp
      @tmp_path = Tmp.new.path
      @backup_path = "#{@tmp_path}/database-#{@timestamp}.sqlite3"
      @tar_path = "#{@tmp_path}/database-#{@timestamp}.tgz"
      @gpg_path = "#{@tar_path}.gpg"
    end

    def call
      Sqlite.new(database_path: @database_path, backup_path: @backup_path).call
      Tar.new(tar_path: @tar_path, path_or_paths: @backup_path).call
      Gpg.new(@tar_path).call(@gpg_passphrase)
      S3.new(@gpg_path).call(**@s3_setup)
    ensure
      Clean.new([@backup_path, @tar_path]).call
    end
  end
end
