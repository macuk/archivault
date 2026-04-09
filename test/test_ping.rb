# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestPing < Minitest::Test
    def test_call_makes_http_request
      mock_response = Object.new

      Net::HTTP.stub(:get_response, mock_response) do
        ping = Ping.new("https://example.com/ping")
        result = ping.call

        assert_equal mock_response, result
      end
    end

    def test_raises_when_ping_url_is_nil
      error = assert_raises(ArgumentError) { Ping.new(nil) }

      assert_equal("ping_url is required", error.message)
    end

    def test_raises_when_ping_url_is_empty_string
      error = assert_raises(ArgumentError) { Ping.new("") }

      assert_equal("ping_url is required", error.message)
    end

    def test_converts_ping_url_to_string
      mock_response = Object.new
      url_object = Object.new
      url_object.define_singleton_method(:to_s) { "https://example.com/ping" }
      url_object.define_singleton_method(:nil?) { false }
      url_object.define_singleton_method(:empty?) { false }

      Net::HTTP.stub(:get_response, mock_response) do
        ping = Ping.new(url_object)
        result = ping.call

        assert_equal mock_response, result
      end
    end
  end
end
