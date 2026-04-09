# frozen_string_literal: true

module Archivault
  class Gpg
    def initialize(file_path)
      raise ArgumentError, "file_path must not be nil" if file_path.nil? || file_path.to_s.empty?

      @file_path = file_path.to_s
    end

    def call(passphrase)
      raise ArgumentError, "passphrase is blank" if passphrase.to_s.strip.empty?

      Execute.new.call(
        "gpg",
        "--batch",
        "--yes",
        "--symmetric",
        "--cipher-algo", "AES256",
        "--passphrase", passphrase,
        @file_path
      )
    end
  end
end
