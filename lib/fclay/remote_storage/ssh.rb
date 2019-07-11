class Fclay::RemoteStorage::SSH

  attr_accessor :name, :uploading_object, :storage, :options

  def initialize(uploading_object)
    @name = 'ssh'
    @uploading_object = uploading_object
    @storage = Fclay.configuration.remote_storages['ssh']
    @options = @uploading_object.class.fclay_options
  end

  def upload
    (@options[:styles].try(:keys) || [nil]).each do |style|
      command = "ssh #{hosting} 'mkdir -p #{remote_dir(style)}'"
      system(command)
      command = "scp -r #{local_file(style)} #{hosting}:#{remote_file(style)}"
      system(command)
    end

    uploading_object.update(file_status: 'idle', file_location: name)
    uploading_object.try(:log,"Sucessful uploaded! file_status: 'idle', file_location: #{name}")
    uploading_object.delete_local_files
    uploading_object.try(:uploaded)

  end

  def delete_files
    (@options[:styles].try(:keys) || [nil]).each do |style|
      command = "ssh #{hosting} 'rm #{remote_file(style)}'"
      system(command)
    end
  end

  def hosting
    "#{storage[:user]}@#{storage[:host]}"
  end

  def hosting_path
    "/home/#{storage[:user]}/#{storage[:bucket]}/"
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
