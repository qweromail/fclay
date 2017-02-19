module Fclay
  class RemoteStorage
    
    def initialize data
      @data = data
    end
    
    def bucket_name
      if @data.kind == "s3"
        Fclay.configuration.remote_storages[@name][:bucket]
      else
        ""
      end
    end
    
  end
end