module Fclay
  module RemoteStorage
    
    KINDS = [:s3, :yadisk]
    
    def initialize name
      @name = name
    end
    
    def self.fetch 
      RemoteStorage.new Fclay.configuration.storage_policy
    end
    
    def bucket_name
      if @name == "s3"
        Fclay.configuration.remote_storages[@name][:bucket]
      else
        ""
    end
    
  end
end