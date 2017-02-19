require "fclay/version"
require 'fclay/configuration'
require 'fclay/upload_job'
require "fclay/attachment"
require "fclay/includer"
require "fclay/remote_storage"

module Fclay
  class << self  
    def configure(&block)
      yield(configuration)
      validate_configuration
      configuration
    end
  
    def remote_storage
      @_remote_storage ||= RemoteStorage.new(configuration.remote_storages[configuration.storage_policy])
    end
  
    def configuration
      @_configuration ||= Configuration.new
    end
      
    def validate_configuration
      validate_remote_storages unless configuration.storage_policy == :local 
    end
    
    def validate_remote_storages
      raise ArgumentError, "remote storage '#{configuration.storage_policy}' not set" unless configuration.remote_storages[configuration.storage_policy].present?
    end
    
    ActiveSupport.on_load(:active_record) do
      extend Fclay::Includer
    end
    
  end
  
end



