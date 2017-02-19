require 'rails/generators/active_record'

class FclayGenerator < ActiveRecord::Generators::Base
 

  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def generate_migration
    migration_template "fclay_migration.rb.erb", "db/migrate/#{migration_file_name}"
  end

  def migration_name
    "add_fclay_fields_to_#{name.underscore.pluralize}"
  end

  def migration_file_name
    "#{migration_name}.rb"
  end

  def migration_class_name
    migration_name.camelize
  end
end
