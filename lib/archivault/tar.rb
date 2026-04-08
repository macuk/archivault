# frozen_string_literal: true

module Archivault
  class Tar
    def initialize(tar_path:, path_or_paths:)
      raise ArgumentError, "tar_path must not be nil" if tar_path.nil? || tar_path.to_s.empty?

      @tar_path = tar_path.to_s

      @paths = Array(path_or_paths)
      raise ArgumentError, "path_or_paths must not be empty" if @paths.empty?
    end

    def call
      @paths.each do |path|
        raise ArgumentError, "path must be a non-empty String" if path.nil? || path.to_s.empty?
      end

      Execute.new.call("tar", "-czf", @tar_path, *@paths.map(&:to_s))
    end
  end
end
