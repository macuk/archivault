# frozen_string_literal: true

module Archivault
  class Ping
    def initialize(ping_url)
      raise ArgumentError, "ping_url is required" if ping_url.nil? || ping_url.to_s.empty?

      @ping_url = ping_url.to_s
    end

    def call
      Net::HTTP.get_response(URI(@ping_url))
    end
  end
end
