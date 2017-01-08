module Fclay
  module Includer
    
    def has_fclay_attachment options = {}
      @fclay_options = options
      
      class_eval do
         def self.fclay_options
           @fclay_options
         end
      end
      
      include Fclay::Attachment
    end
    
  end
end