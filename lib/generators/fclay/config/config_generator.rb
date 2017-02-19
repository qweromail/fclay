require 'rails/generators/active_record'

class Fclay::ConfigGenerator < ActiveRecord::Generators::Base
 

  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  initializer "begin.rb" do
    "puts 'this is the beginning'"
  end
  
  
end
