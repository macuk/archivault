# frozen_string_literal: true

module Archivault
  class Tmp
    attr_reader :path

    def initialize(path: "/tmp")
      @path = defined?(Rails) ? Rails.root.join("tmp").to_s : path
    end
  end
end
