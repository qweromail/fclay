class Fclay::RemoteStorage::S3

  attr_accessor :name, :uploading_object, :storage, :options

  def initialize(uploading_object)
    @name = 's3'
    @uploading_object = uploading_object
    @storage = Fclay.configuration.remote_storages['s3']
    @options = @uploading_object.class.fclay_options
    @bucket = Aws::S3::Resource.new.bucket(bucket_name)
  end

  def upload

    (@options[:styles].try(:keys) || [nil]).each do |style|
       obj = @bucket.object(uploading_object.remote_file_path(style))
       obj.put({
         body: File.read(uploading_object.local_file_path(style)),
         acl: "public-read",
         content_type: content_type
       })
    end

    uploading_object.update(file_status: 'idle', file_location: name)
    uploading_object.try(:log,"Sucessful uploaded! file_status: 'idle', file_location: #{name}")
    uploading_object.delete_local_files
    uploading_object.try(:uploaded)

  end

  def content_type
    uploading_object.try(:content_type)
  end

  def bucket_name
    @options[:bucket]
  end

  def delete_files

    (@options[:styles].try(:keys) || [nil]).each do |style|
      @bucket.object(remote_file_path(style)).delete
    end

  end

end
