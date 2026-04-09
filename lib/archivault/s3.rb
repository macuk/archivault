# frozen_string_literal: true

require "aws-sdk-s3"

module Archivault
  class S3
    def initialize(file_path)
      raise ArgumentError, "file_path is required" if file_path.nil? || file_path.to_s.empty?

      @file_path = file_path.to_s
    end

    def call(region:, access_key_id:, secret_access_key:, bucket:)
      validate_call_arguments!(region:, access_key_id:, secret_access_key:, bucket:)

      basename = File.basename(@file_path)
      bucket_path = basename.sub(/^(.+)-(\d{4})-(\d{2}).*/, '\1/\2/\3/')
      key = bucket_path + basename

      s3_client = Aws::S3::Client.new(region:, access_key_id:, secret_access_key:)
      transfer_manager = Aws::S3::TransferManager.new(client: s3_client)
      status = transfer_manager.upload_file(
        @file_path, bucket:, key:, storage_class: "STANDARD_IA"
      )
      raise S3Error, "Failed AWS S3 upload command" unless status
    end

    private

    def validate_call_arguments!(region:, access_key_id:, secret_access_key:, bucket:)
      {
        region:,
        access_key_id:,
        secret_access_key:,
        bucket:
      }.each do |name, value|
        raise ArgumentError, "#{name} is required" if value.nil? || value.to_s.empty?
      end
    end
  end
end
