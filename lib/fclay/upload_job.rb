module Fclay
  class UploadJob < ActiveJob::Base
    queue_as :default

    def perform type,id
      Fclay::Attachment.upload(type,id)
    end
  end
end
