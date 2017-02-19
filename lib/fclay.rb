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
  
    def configuration
      @_configuration ||= Configuration.new
    end
      
    def validate_configuration
      validate_remote_storages if @_configuration.storage_policy != "local"
    end
    
    def validate_remote_storages
      (@_configuration.storage_policy.split(",") - ["local"]).each do |f|
        raise ArgumentError, "remote storage '#{f}' not set" unless @_configuration.remote_storages[f].present?
      end
    end
    
    ActiveSupport.on_load(:active_record) do
      extend Fclay::Includer
    end
    
  end
  
end



