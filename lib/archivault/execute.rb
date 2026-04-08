# frozen_string_literal: true

require "English"

module Archivault
  class Execute
    def call(command, *)
      status = system(command, *)
      raise ExecuteError, "#{command} could not be executed" if status.nil?
      raise ExecuteError, "#{command} failed with exit code #{$CHILD_STATUS&.exitstatus}" unless status

      status
    end
  end
end
