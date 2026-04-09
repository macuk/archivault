# frozen_string_literal: true

require "fileutils"

module Archivault
  class Clean
    def initialize(path_or_paths)
      @paths = Array(path_or_paths)
      raise ArgumentError, "path_or_paths is required" if @paths.empty?
    end

    def call
      @paths.each do |path|
        raise ArgumentError, "path is required" if path.nil? || path.to_s.empty?

        FileUtils.rm(path.to_s)
      end
    end
  end
end
