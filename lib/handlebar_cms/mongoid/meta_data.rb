module HandlebarCms
  module Mongoid
    module MetaData
      extend ActiveSupport::Concern
  
      included do
        field :meta_data, :type => Hash, :default => self.meta_tags

        before_save :convert_period
        after_initialize :convert_unicode_period
      end

      module InstanceMethods
        private
          def convert_period
            new_hash = Hash.new
            meta_data.each_pair do |k,v|
              if k =~ /\./
                new_key = k.sub(/\./, '\U+002E')
                new_hash[new_key] = v
              else
                new_hash[k] = v
              end 
            end 
            meta_data.replace(new_hash)
          end

          def convert_unicode_period
           new_hash = Hash.new
            meta_data.each_pair do |k,v|
              if k =~ /\\\U\+002E/
                new_key = k.sub(/\\\U\+002E/, "\u002E")
                new_hash[new_key] = v
              else
                new_hash[k] = v
              end 
            end 
            meta_data.replace(new_hash)
          end
      end
    
      module ClassMethods

        def meta_tags
          { "title" => nil, "keywords" => nil, "description" => nil } 
        end
      end

    end
  end
end
