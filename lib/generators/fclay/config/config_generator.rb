require 'rails/generators/active_record'

class Fclay::ConfigGenerator < ActiveRecord::Generators::Base
 
  def create_initializer_file
    create_file "config/initializers/fclay.rb" do 
"Fclay.configure do |config|
  #config.local_storage_assets_host = 'http://mysite.com'
  #config.storage_policy = :s3
  #config.storages do |storages|
  #  storages[:s3] = {
  #    :kind => 'aws',
  #    :bucket => 'bucket-name'
  #  }
  #end
end"
      
    end
  end
  
  
end
