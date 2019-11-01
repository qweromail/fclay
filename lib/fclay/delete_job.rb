module Fclay
  class DeleteJob < ActiveJob::Base

    queue_as :default

    def perform(file)
      puts 'Deleting progress!!!!'
      FileUtils.rm(file, { force: true })
    end

  end
end
