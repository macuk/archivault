# frozen_string_literal: true

require "securerandom"

module Archivault
  class Timestamp
    attr_reader :timestamp

    def initialize
      @timestamp = Time.now.strftime("%Y-%m-%d-%H-%M")
    end

    # The backup S3 key may only PutObject, which can also overwrite an existing object.
    # It can't list the bucket, so an unguessable suffix keeps it from targeting existing backups.
    def backup_name(prefix)
      "#{prefix}-#{timestamp}-#{SecureRandom.hex(8)}"
    end
  end
end
