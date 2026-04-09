# frozen_string_literal: true

require_relative "archivault/version"
require_relative "archivault/timestamp"
require_relative "archivault/execute"
require_relative "archivault/sqlite"
require_relative "archivault/clean"
require_relative "archivault/tar"
require_relative "archivault/tmp"
require_relative "archivault/gpg"
require_relative "archivault/s3"
require_relative "archivault/sqlite_backup"
require_relative "archivault/logs_backup"

module Archivault
  class Error < StandardError; end
  class ExecuteError < Error; end
  class S3Error < Error; end
  # Your code goes here...
end
