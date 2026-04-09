# frozen_string_literal: true

module Archivault
  class SqliteBackup
    # Parameters
    #   - database_path: Path to the SQLite3 database file
    #   - gpg_passphrase: GPG passphrase to encrypt the backup file
    #   - s3_setup: Hash of S3 setup options:
    #     - region: AWS region
    #     - access_key_id: AWS access key ID
    #     - secret_access_key: AWS secret access key
    #     - bucket: S3 bucket name
    def initialize(database_path:, gpg_passphrase:, s3_setup:, ping_url: nil)
      @database_path = database_path.to_s
      @gpg_passphrase = gpg_passphrase.to_s
      @s3_setup = s3_setup
      @ping_url = ping_url

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
      Ping.new(@ping_url).call if @ping_url
    ensure
      Clean.new([@backup_path, @tar_path, @gpg_path]).call
    end
  end
end
