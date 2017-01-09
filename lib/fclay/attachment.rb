module Fclay  
  module Attachment

    extend ActiveSupport::Concern
    
    CALLBACKS = [:process,:upload,:delete]
    
    
    included do 
      
      callbacks = CALLBACKS
     
      case fclay_options[:without].class.name
        when "Symbol"
          callbacks.clear if fclay_options[:without] == :all
        when "Array"
          callbacks -= fclay_options[:without]
      end 
      
      before_create :process_file if callbacks.include? :process
      after_create :upload_later if callbacks.include? :upload
      before_destroy :delete_files if callbacks.include? :delete
    
    end

    attr_accessor :file
    
    def delete_files
      
      case file_status 
        when 'in_remote_storage'
          delete_remote_files
        when 'in_local_storage'
          delete_local_files
      end
    
    end
    
    def upload_later
      Fclay::UploadJob.perform_later self.class.name,self.id
    end
    
    def upload
      Fclay::Attachment.upload self.class.name,self.id
    end
    
    def self.upload type,id

       type = type.constantize
       uploading_object = type.find(id)
       return if uploading_object.file_status == "in_remote_storage"
       content_type  = uploading_object.try(:content_type)
       bucket = bucket_object
       
       (uploading_object.class.fclay_options[:styles] || [nil]).each do |style|
         obj = bucket.object(uploading_object.remote_file_path(style))
         obj.put({
           body: File.read(uploading_object.local_file_path(style)),
           acl: "public-read",
           content_type: uploading_object.class.fclay_options[:content_type]
         })
       end
      
       if uploading_object.update_attribute(:file_status, 'in_remote_storage')
         uploading_object.delete_local_files
       end
       uploading_object.try(:uploaded)

    end

    def fclay_attachment_presence
     errors.add(:file, 'must be present') if id.blank? && !@file
    end

    def file_size_mb 

      "#{((self.file_size >> 10).to_f / 1024).round(2)} Mb" if self.file_size 

    end

    def file_url_style_sync 

      file_url(:sync)

    end

    def file_url(style=nil)

      case file_status
        when "in_local_storage"
          local_file_url(style)
        when "in_remote_storage"
          remote_file_url(style)
        end
    end

    def remote_file_url(style=nil)
      "http://#{Fclay::RemoteStorage.bucket_name}.s3.amazonaws.com/#{remote_file_path(style)}"
    end

    def local_file_path(style=nil)

       local_file_dir(style) + "/" + file_name

    end

    def local_file_url(style=nil)
       if Rails.env.development?
         url = Fclay.configuration.local_storage_development_assets_host
       else
         url = Fclay.configuration.local_storage_production_assets_host
       end
       url += "#{Fclay.configuration.local_url}/#{self.class.name.tableize}"
       url += "/#{style.to_s}" if style && style != :nil 
       url += "/#{file_name}"
       url
    end

    def short_local_file_url(style=nil)
  
    end

    def local_file_dir(style=nil) 
     dir = "#{Rails.root.to_s + Fclay.configuration.local_folder}/#{self.class.name.tableize}"
     dir += "/#{style.to_s}" if style   
     dir
    end

    def remote_file_path(style=nil)
      path = ""
      path += "#{self.class.name.tableize}"
      path += "/#{style.to_s}" if style
      path += "/#{file_name}"
      path    
    end

    def delete_tmp_file 
       FileUtils.rm(@file.try(:path) || @file[:path],{:force => true}) if @file
       @file = nil
    end

    def create_dirs

     (self.class.fclay_options[:styles] || [nil]).each do |style|
       FileUtils.mkdir_p(local_file_dir(style))
     end

    end

    def process_file
  
      return unless @file

      # TODO: refactor this
      # if self.file_status == 'in_remote_storage'
#         self.class.name.constantize::STYLES.each do |style|
#            S3.delay(:queue => "backend").delete_s3_file s3_file_path(style)
#         end
#         self.file_status = 'new'
#       end

      create_dirs
      fetch_file_name unless self.file_name.present?

      FileUtils.mv(@file.try(:path) || @file[:path],local_file_path)
      `chmod 0755 #{local_file_path}`

      delete_tmp_file
      set_file_size
      self.file_status = 'in_local_storage'
 
    end
    
    def fetch_file_name
      
      ext = self.class.fclay_options[:extension]
      if !ext && @file.original_filename
        filename_part = @file.original_filename.split(".")
        ext = "#{filename_part.last}" if filename_part.size > 1
      end

      self.file_name = try(:generate_filename)
      self.file_name = SecureRandom.hex unless file_name
      self.file_name += ".#{ext}" if ext
      
    end

    def delete_local_files 

       begin
          (self.class.fclay_options[:styles] || [nil]).each do |style|
            FileUtils.rm(local_file_path(style),{:force => true})
          end
       rescue
          Rails.logger.info "Deleting Media #{id} sync file not found"
       end

    end  

    def delete_remote_files
      
      (self.class.fclay_options[:styles] || [nil]).each do |style|
        Fclay::Attachment.bucket_object.object(remote_file_path(style)).delete
      end
    end
    
    def set_file_size style=:nil
      self.file_size = File.size local_file_path(style)
    end
    
    def self.resolve_file_url navigation_complex_id,type,file_name,style=nil
  
      return "" if file_name.nil? || type.nil?
  
      path = "http://s3.amazonaws.com/#{Fclay::RemoteStorage.bucket_name}"
      path += "/navigation_complex/#{navigation_complex_id}" if navigation_complex_id
      path += "/#{type}"
      path += "/#{style.to_s}" if style
      path += "/#{file_name}"
      path
    end 

    def self.bucket_object
      s3 = Aws::S3::Resource.new
      s3.bucket(Fclay::RemoteStorage.bucket_name)
    end

  end
end

