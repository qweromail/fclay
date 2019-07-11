require_relative './ssh'
require_relative './s3'

class Fclay::RemoteStorage::Factory

  def self.for(storage, uploading_object)
    case storage
    when 'ssh'
      Fclay::RemoteStorage::SSH.new(uploading_object)
    when 's3'
      Fclay::RemoteStorage::S3.new(uploading_object)
    else
      raise 'Unsupported storage type'
    end
  end

end
