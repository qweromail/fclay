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
      @_remote_storage ||= RemoteStorage.new(configuration.storage_policy,configuration.remote_storages[configuration.storage_policy])
    end
  
    def configuration
      @_configuration ||= Configuration.new
    end
      
    def validate_configuration
      validate_remote_storages unless configuration.storage_policy == :local 
    end
    
    def validate_remote_storages
      raise ArgumentError, "remote storage '#{configuration.storage_policy}' not set" unless configuration.remote_storages[configuration.storage_policy].present?
        
      validate_s3 if configuration.remote_storages[configuration.storage_policy][:kind] == "s3"
      
          
    end
    
    def validate_s3
      
      raise ArgumentError, "Aws constant not definded. Missed aws-sdk gem?" unless defined? Aws
      %w(AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION).each do |key|
        raise ArgumentError, "Missed ENV[\"#{key}\"]" unless ENV[key]
      end
        
      
    end
    
    
    ActiveSupport.on_load(:active_record) do
      extend Fclay::Includer
    end
    
  end
  
end



