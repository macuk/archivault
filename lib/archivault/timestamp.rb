# frozen_string_literal: true

module Archivault
  class Timestamp
    attr_reader :timestamp

    def initialize
      @timestamp = Time.now.strftime("%Y-%m-%d-%H-%M")
    end
  end
end
