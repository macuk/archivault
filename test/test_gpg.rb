# frozen_string_literal: true

require "test_helper"

module Archivault
  # rubocop: disable Metrics/MethodLength
  class TestGpg < Minitest::Test
    def test_initialize_raises_when_file_path_is_nil
      error = assert_raises(ArgumentError) { Gpg.new(nil) }

      assert_equal("file_path is required", error.message)
    end

    def test_initialize_raises_when_file_path_is_empty
      error = assert_raises(ArgumentError) { Gpg.new("") }

      assert_equal("file_path is required", error.message)
    end

    def test_call_raises_when_passphrase_is_nil
      error = assert_raises(ArgumentError) { Gpg.new("/tmp/archive.tar.gz").call(nil) }

      assert_equal("passphrase is required", error.message)
    end

    def test_call_raises_when_passphrase_is_empty
      error = assert_raises(ArgumentError) { Gpg.new("/tmp/archive.tar.gz").call("") }

      assert_equal("passphrase is required", error.message)
    end

    def test_call_executes_gpg
      input_path = "/tmp/archive.tar.gz"
      passphrase = "secret"
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [
                    "gpg", "--batch", "--yes", "--symmetric",
                    "--cipher-algo", "AES256",
                    "--passphrase", passphrase,
                    input_path
                  ])

      gpg = Gpg.new(input_path)
      result = Execute.stub(:new, ->(*) { mock }) { gpg.call(passphrase) }

      assert_nil(result)
      mock.verify
    end
  end
  # rubocop: enable Metrics/MethodLength
end
