require_relative './ssh'
require_relative './s3'

class Fclay::RemoteStorage::Provider

  def self.get_provider_class(storage)
    case storage
    when 'ssh'
      Fclay::RemoteStorage::SSH
    when 's3'
      Fclay::RemoteStorage::S3
    else
      raise 'Unsupported storage type'
    end
  end

  def self.provider_for(storage, uploading_object)
    klass = get_provider_class(storage)
    klass.new(uploading_object)
  end


  def self.upload(uploading_object)
    options = uploading_object.class.fclay_options

    if options[:primary].present?
      storage = provider_for(options[:primary], uploading_object)
      storage.upload

      if options[:secondary].present?
        storage = provider_for(options[:secondary], uploading_object)
        storage.upload(without_update: true)
      end
    else
      storage = provider_for(Fclay.configuration.storage_policy, uploading_object)
      storage.upload
    end

    uploading_object.delete_local_files
  end

  def self.delete_files(model)
    options = model.class.fclay_options

    if options[:primary].present?
      storage = provider_for(options[:primary], model)
      storage.delete_files

      if options[:secondary].present?
        storage = provider_for(options[:secondary], model)
        storage.delete_files
      end
    else
      storage = provider_for(Fclay.configuration.storage_policy, model)
      storage.delete_files
    end
  end

  def self.remote_file_url(obj, style = nil)
    klass = get_provider_class(obj.file_location)
    "#{klass.url}/#{obj.remote_file_path(style)}"
  end

end
