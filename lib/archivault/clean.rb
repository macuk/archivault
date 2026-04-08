# frozen_string_literal: true

require "fileutils"

module Archivault
  class Clean
    def initialize(path_or_paths)
      @path_or_paths = path_or_paths
    end

    def call
      paths = Array(@path_or_paths)
      raise ArgumentError, "path_or_paths must not be empty" if paths.empty?

      paths.each do |path|
        raise ArgumentError, "path must be a non-empty String" if path.nil? || path.to_s.empty?

        FileUtils.rm(path.to_s)
      end
    end
  end
end
