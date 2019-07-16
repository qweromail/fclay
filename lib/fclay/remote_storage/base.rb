class Fclay::RemoteStorage::Base

  attr_accessor :name, :uploading_object, :storage, :options

  def initialize(name, uploading_object)
    @name = name
    @uploading_object = uploading_object
    @storage = get_storage_by_name(name)
    @options = @uploading_object.class.fclay_options
  end

  def upload(options = {})
    uploading_object.update(file_status: 'idle', file_location: name)
    uploading_object.try(:log, "Sucessful uploaded! file_status: 'idle', file_location: #{name}")
    uploading_object.try(:uploaded)
  end

  def delete_files
  end

  def self.url(name = nil)
  end

  def get_storage_by_name(name)
    Fclay.configuration.remote_storages[name]
  end

end
