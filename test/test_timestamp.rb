# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestTimestamp < Minitest::Test
    def test_timestamp
      assert_match(/\d{4}-\d{2}-\d{2}-\d{2}-\d{2}/, Timestamp.new.timestamp)
    end
  end
end
