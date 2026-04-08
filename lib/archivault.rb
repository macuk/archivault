# frozen_string_literal: true

require_relative "archivault/version"
require_relative "archivault/timestamp"
require_relative "archivault/execute"
require_relative "archivault/sqlite"
require_relative "archivault/clean"

module Archivault
  class Error < StandardError; end
  class ExecuteError < Error; end
  # Your code goes here...
end
