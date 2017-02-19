module Fclay
  class Configuration
    attr_accessor :local_storage_host
    attr_accessor :storage_policy
    attr_accessor :remote_storages
    attr_accessor :local_url
    attr_accessor :local_folder
    
    def initialize
      @local_storage_host = ""
      @storage_policy = "local"
      @remote_storages = {}
      @local_url = "/system/local_storage"
      @local_folder = "/public#{@local_url}"
    end
  end
end