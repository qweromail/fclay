module Fclay
  class RemoteStorage
    
    attr_reader :name
    
    def initialize name,data
      @name = name.to_s
      @data = data
    end
    
    def s3?
      return false unless @data
      @data[:kind] == "s3"
    end
    
    def bucket_object
      return nil if !@data || !s3? 
      s3 = Aws::S3::Resource.new
      s3.bucket(bucket_name)
    end
    
    def bucket_name
      return "" unless s3?
      @data[:bucket]
    end
    
  end
end