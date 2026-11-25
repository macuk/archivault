# frozen_string_literal: true

require "test_helper"

module Archivault
  class TestTimestamp < Minitest::Test
    def test_timestamp
      assert_match(/\d{4}-\d{2}-\d{2}-\d{2}-\d{2}/, Timestamp.new.timestamp)
    end

    def test_backup_name_has_prefix_timestamp_and_random_suffix
      timestamp = Timestamp.new

      assert_match(/\Adatabase-#{timestamp.timestamp}-\h{16}\z/, timestamp.backup_name("database"))
    end

    def test_backup_name_is_unique
      timestamp = Timestamp.new

      refute_equal(timestamp.backup_name("database"), timestamp.backup_name("database"))
    end

    def test_backup_name_is_compatible_with_s3_key_layout
      name = "#{Timestamp.new.backup_name("my-app")}.dump"

      assert_equal("my-app/#{Time.now.strftime("%Y/%m")}/", name.sub(/^(.+)-(\d{4})-(\d{2}).*/, '\1/\2/\3/'))
    end
  end
end
