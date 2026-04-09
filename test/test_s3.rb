# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestS3 < Minitest::Test
    def test_initialize_raises_when_file_path_is_nil
      error = assert_raises(ArgumentError) { S3.new(nil) }

      assert_equal("file_path must not be nil", error.message)
    end

    def test_initialize_raises_when_file_path_is_empty
      error = assert_raises(ArgumentError) { S3.new("") }

      assert_equal("file_path must not be nil", error.message)
    end

    def test_call_uploads_file_with_expected_bucket_key
      captured_upload = {}
      s3_client = Object.new
      transfer_manager = build_success_transfer_manager(captured_upload)

      Aws::S3::Client.stub(:new, client_builder(s3_client)) do
        Aws::S3::TransferManager.stub(:new, transfer_manager_builder(s3_client, transfer_manager)) do
          S3.new("/tmp/my-app-2025-03-archive.tar.gz").call(**example_call_params)
        end
      end

      assert_equal(expected_upload_data, captured_upload)
    end

    def test_call_raises_when_required_argument_is_nil
      %i[region access_key_id secret_access_key bucket].each do |argument|
        params = example_call_params
        params[argument] = nil

        error = assert_raises(ArgumentError) do
          S3.new("/tmp/my-app-2025-03-archive.tar.gz").call(**params)
        end

        assert_equal("#{argument} is blank", error.message)
      end
    end

    def test_call_raises_when_required_argument_is_empty
      %i[region access_key_id secret_access_key bucket].each do |argument|
        params = example_call_params
        params[argument] = ""

        error = assert_raises(ArgumentError) do
          S3.new("/tmp/my-app-2025-03-archive.tar.gz").call(**params)
        end

        assert_equal("#{argument} is blank", error.message)
      end
    end

    def test_call_raises_when_upload_fails
      transfer_manager = Object.new
      transfer_manager.define_singleton_method(:upload_file) do |*_, **_kwargs|
        nil
      end

      Aws::S3::Client.stub(:new, ->(**_) { Object.new }) do
        Aws::S3::TransferManager.stub(:new, ->(**_) { transfer_manager }) do
          error = assert_raises(S3Error) do
            S3.new("/tmp/my-app-2025-03-archive.tar.gz").call(**example_call_params)
          end

          assert_equal("Failed AWS S3 upload command", error.message)
        end
      end
    end

    private

    def example_call_params
      {
        region: "eu-central-1",
        access_key_id: "AKIA123",
        secret_access_key: "secret",
        bucket: "backups"
      }
    end

    def expected_upload_data
      {
        uploaded_file_path: "/tmp/my-app-2025-03-archive.tar.gz",
        bucket: "backups",
        key: "my-app/2025/03/my-app-2025-03-archive.tar.gz",
        storage_class: "STANDARD_IA"
      }
    end

    def build_success_transfer_manager(captured_upload)
      transfer_manager = Object.new
      transfer_manager.define_singleton_method(:upload_file) do |uploaded_file_path, bucket:, key:, storage_class:|
        captured_upload[:uploaded_file_path] = uploaded_file_path
        captured_upload[:bucket] = bucket
        captured_upload[:key] = key
        captured_upload[:storage_class] = storage_class
        true
      end
      transfer_manager
    end

    def client_builder(s3_client)
      lambda do |region:, access_key_id:, secret_access_key:|
        assert_equal("eu-central-1", region)
        assert_equal("AKIA123", access_key_id)
        assert_equal("secret", secret_access_key)
        s3_client
      end
    end

    def transfer_manager_builder(s3_client, transfer_manager)
      lambda do |client:|
        assert_same(s3_client, client)
        transfer_manager
      end
    end
  end
end
