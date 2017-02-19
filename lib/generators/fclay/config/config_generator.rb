require 'rails/generators/active_record'

class Fclay::ConfigGenerator < ActiveRecord::Generators::Base
 
  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def create_initializer_file
    create_file "config/initializers/fclay.rb" do 
      
      "BAR"
      
    end
  end
  
  
end
