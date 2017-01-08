module Fclay
  class Configuration
    attr_accessor :local_storage_development_assets_host
    attr_accessor :local_storage_production_assets_host
    attr_accessor :storage_mode
    attr_accessor :remote_storages
    attr_accessor :local_url
    attr_accessor :local_folder
    
    def initialize
      @local_storage_development_assets_host = "http://localhost:3000"
      @local_storage_production_assets_host = ""
      @storage_mode = "local"
      @remote_storages = {}
      @local_url = "/system/local_storage"
      @local_folder = "/public#{@local_url}"
    end
  end
end