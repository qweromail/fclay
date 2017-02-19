require 'rails/generators/active_record'

class Fclay::ConfigGenerator < ActiveRecord::Generators::Base
 
  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def create_initializer_file
    create_file "config/initializers/fclay.rb" do 
      "require 'fclay'
        Fclay.configure do |config|
          config.local_storage_assets_host = 'http://mysite.com'
          config.storage_mode = 's3'
          config.remote_storages = {
            's3' => {
              kind: 'aws',
              bucket: 'bucket_name',
            }
          }
        end
      "
      
    end
  end
  
  
end
