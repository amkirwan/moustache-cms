module HandlebarCms
  module Mongoid
    module MetaData
      extend ActiveSupport::Concern
  
      included do
        field :default_meta_data, :type => Hash, :default => self.default_meta_tags
        field :additional_meta_data, :type => Array, :default => []
      end
    
      module ClassMethods
        def default_meta_tags
          { "title" => nil, "keywords" => nil, "description" => nil } 
        end
      end

    end
  end
end
