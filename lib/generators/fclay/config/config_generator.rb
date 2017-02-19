require 'rails/generators/active_record'

class Fclay::ConfigGenerator < ActiveRecord::Generators::Base
 
  desc "This generator creates an initializer file at config/initializers"

  def create_initializer_file
    create_file "config/initializers/initializer.rb", "# Add initialization content here"
  end
  
  
end
