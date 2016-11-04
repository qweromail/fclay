module Fclay
  class Configuration
    attr_accessor :local_storage_development_assets_host
    attr_accessor :local_storage_production_assets_host
    
    def initialize
      @local_storage_development_assets_host = "http://localhost:3000"
      @local_storage_production_assets_host = ""
    end
  end
end