module Fclay
  module RemoteStorage
    
    def self.bucket_name
      return unless Fclay.configuration.remote_storages[Fclay.configuration.storage_mode]
      Fclay.configuration.remote_storages[Fclay.configuration.storage_mode][:bucket]
    end
    
  end
end