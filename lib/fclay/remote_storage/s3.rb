require_relative './base'

class Fclay::RemoteStorage::S3 < Fclay::RemoteStorage::Base

  def initialize(name, uploading_object)
    super

    @bucket = Aws::S3::Resource.new.bucket(bucket_name)
  end

  def upload(options = {})
    (@options[:styles].try(:keys) || [nil]).each do |style|
       begin
         obj = bucket_object(style)
         obj.put({
           body: File.read(uploading_object.local_file_path(style)),
           acl: "public-read",
           content_type: content_type
         })
       rescue => e
         Rails.logger.debug(e.message)
       end
    end

    super unless options[:without_update]
  end

  def delete_files
    (@options[:styles].try(:keys) || [nil]).each do |style|
      bucket_object(style).delete
    end
  end

  def bucket_object(style = nil)
    @bucket.object(uploading_object.remote_file_path(style))
  end

  def self.url(name = nil)
    return '' unless name
    storage = Fclay.configuration.remote_storages[name]
    if (storage[:cloudfront].present?)
      "https://#{storage[:cloudfront]}.cloudfront.net"
    else
      "https://#{storage[:bucket]}.s3.amazonaws.com"
    end
  end

  def content_type
    uploading_object.try(:content_type)
  end

  def bucket_name
    Fclay.configuration.remote_storages[name][:bucket]
  end

end
