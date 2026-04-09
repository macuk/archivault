# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestTar < Minitest::Test
    def test_call_with_single_path
      mock = Minitest::Mock.new
      mock.expect(:call, nil) do |*args, **kwargs|
        args == %w[tar -czf /tmp/archive.tar.gz /app/log/app.log] &&
          kwargs == { out: File::NULL, err: File::NULL }
      end

      tar = Tar.new(tar_path: "/tmp/archive.tar.gz", path_or_paths: "/app/log/app.log")
      Execute.stub(:new, ->(*) { mock }) { tar.call }
      mock.verify
    end

    def test_call_with_multiple_paths
      mock = Minitest::Mock.new
      mock.expect(:call, nil) do |*args, **kwargs|
        args == %w[tar -czf /tmp/archive.tar.gz /tmp/one /tmp/two] &&
          kwargs == { out: File::NULL, err: File::NULL }
      end

      tar = Tar.new(tar_path: "/tmp/archive.tar.gz", path_or_paths: %w[/tmp/one /tmp/two])
      Execute.stub(:new, ->(*) { mock }) { tar.call }
      mock.verify
    end

    def test_call_raises_when_paths_array_is_empty
      error = assert_raises(ArgumentError) { Tar.new(tar_path: "/tmp/archive.tar.gz", path_or_paths: []).call }

      assert_equal("path_or_paths is required", error.message)
    end

    def test_call_raises_when_tar_path_is_nil
      error = assert_raises(ArgumentError) { Tar.new(tar_path: nil, path_or_paths: "/app/log/app.log").call }

      assert_equal("tar_path is required", error.message)
    end

    def test_call_raises_when_tar_path_is_empty
      error = assert_raises(ArgumentError) { Tar.new(tar_path: "", path_or_paths: "/app/log/app.log").call }

      assert_equal("tar_path is required", error.message)
    end

    def test_call_raises_when_input_is_nil
      error = assert_raises(ArgumentError) { Tar.new(tar_path: "/tmp/archive.tar.gz", path_or_paths: nil).call }

      assert_equal("path_or_paths is required", error.message)
    end

    def test_call_raises_when_path_is_nil
      error = assert_raises(ArgumentError) { Tar.new(tar_path: "/tmp/archive.tar.gz", path_or_paths: [nil]).call }

      assert_equal("path is required", error.message)
    end

    def test_call_raises_when_path_is_empty
      error = assert_raises(ArgumentError) { Tar.new(tar_path: "/tmp/archive.tar.gz", path_or_paths: "").call }

      assert_equal("path is required", error.message)
    end
  end
end
