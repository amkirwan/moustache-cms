module Etherweb
  module Mongoid
    module MetaData
      extend ActiveSupport::Concern
  
      included do
        field :meta_data, :type => Hash, :default => self.default_meta_tags
        attr_accessible :meta_data
      end
    
      module ClassMethods
        def default_meta_tags
          { :title => nil, :keywords => nil, :description => nil } 
        end
      end

    end
  end
end