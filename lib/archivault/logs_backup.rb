# frozen_string_literal: true

module Archivault
  class LogsBackup
    # Parameters
    #   - log_path_or_paths: Path or array of paths to the log files to back up
    #   - gpg_passphrase: GPG passphrase to encrypt the backup file
    #   - s3_setup: Hash of S3 setup options:
    #     - region: AWS region
    #     - access_key_id: AWS access key ID
    #     - secret_access_key: AWS secret access key
    #     - bucket: S3 bucket name
    def initialize(log_path_or_paths:, gpg_passphrase:, s3_setup:)
      @log_path_or_paths = log_path_or_paths
      @gpg_passphrase = gpg_passphrase.to_s
      @s3_setup = s3_setup

      @timestamp = Timestamp.new.timestamp
      @tmp_path = Tmp.new.path
      @tar_path = "#{@tmp_path}/logs-#{@timestamp}.tgz"
      @gpg_path = "#{@tar_path}.gpg"
    end

    def call
      Tar.new(tar_path: @tar_path, path_or_paths: @log_path_or_paths).call
      Gpg.new(@tar_path).call(@gpg_passphrase)
      S3.new(@gpg_path).call(**@s3_setup)
    ensure
      Clean.new([@tar_path, @gpg_path]).call
    end
  end
end
