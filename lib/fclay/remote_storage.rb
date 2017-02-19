module Fclay
  class RemoteStorage
    
    def initialize data
      @data = data
    end
    
    def s3?
      @data[:kind] == "s3"
    end
    
    def self.bucket_object
      return "" unless s3? 
      s3 = Aws::S3::Resource.new
      s3.bucket(bucket_name)
    end
    
    def bucket_name
      return "" unless s3?
      @data[:bucket]
    end
    
  end
end