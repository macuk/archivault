# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestClean < Minitest::Test
    def test_call_removes_single_path
      removed_paths = []

      FileUtils.stub(:rm, ->(path) { removed_paths << path }) do
        Clean.new("/tmp/archive.tar.gz").call
      end

      assert_equal(["/tmp/archive.tar.gz"], removed_paths)
    end

    def test_call_removes_all_paths_from_array
      removed_paths = []

      FileUtils.stub(:rm, ->(path) { removed_paths << path }) do
        Clean.new(%w[/tmp/one /tmp/two]).call
      end

      assert_equal(%w[/tmp/one /tmp/two], removed_paths)
    end

    def test_call_raises_when_paths_array_is_empty
      error = assert_raises(ArgumentError) { Clean.new([]).call }

      assert_equal("path_or_paths must not be empty", error.message)
    end

    def test_call_raises_when_input_is_nil
      error = assert_raises(ArgumentError) { Clean.new(nil).call }

      assert_equal("path_or_paths must not be empty", error.message)
    end

    def test_call_raises_when_path_is_nil
      error = assert_raises(ArgumentError) { Clean.new([nil]).call }

      assert_equal("path must be a non-empty String", error.message)
    end

    def test_call_raises_when_path_is_empty
      error = assert_raises(ArgumentError) { Clean.new("").call }

      assert_equal("path must be a non-empty String", error.message)
    end
  end
end
