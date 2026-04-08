# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestExecute < Minitest::Test
    def test_happy_path
      assert Execute.new.call("echo 'hello'")
    end

    def test_nil_status
      assert_raises(Error) { Execute.new.call("false") }
    end

    def test_false_status
      assert_raises(Error) { Execute.new.call("ls", "false") }
    end
  end
end
