require_relative './base'

class Fclay::RemoteStorage::SSH < Fclay::RemoteStorage::Base

  def initialize(name, uploading_object)
    super
  end

  def upload(options = {})
    (@options[:styles].try(:keys) || [nil]).each do |style|
      command = "ssh #{hosting} 'mkdir -p #{remote_dir(style)}'"
      system(command)
      command = "scp -r #{local_file(style)} #{hosting}:#{remote_file(style)}"
      system(command)
    end

    super unless options[:without_update]
  end

  def delete_files
    (@options[:styles].try(:keys) || [nil]).each do |style|
      command = "ssh #{hosting} 'rm #{remote_file(style)}'"
      system(command)
    end
  end

  def self.url(name = nil)
    return '' unless name
    opts = Fclay.configuration.remote_storages[name]
    "https://#{opts[:host]}"
  end

  def hosting
    "#{storage[:user]}@#{storage[:host]}"
  end

  def hosting_path
    "#{storage[:path]}/"
  end

  def local_file(style = nil)
    @uploading_object.local_file_path(style)
  end

  def remote_dir(style = nil)
    dir = "#{hosting_path}#{@uploading_object.class.name.tableize}/"
    dir += "#{style}/" if style
    dir
  end

  def remote_file(style = nil)
    "#{hosting_path}#{@uploading_object.remote_file_path(style)}"
  end

end
