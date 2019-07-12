class Fclay::RemoteStorage::Base

  attr_accessor :name, :uploading_object, :storage, :options

  def upload(options = {})
    uploading_object.update(file_status: 'idle', file_location: name)
    uploading_object.try(:log, "Sucessful uploaded! file_status: 'idle', file_location: #{name}")
    uploading_object.try(:uploaded)
  end

  def delete_files
  end

  def self.url
  end

end
