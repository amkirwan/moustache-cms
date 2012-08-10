module MoustacheCms
  module Mustache
    module AttributeMethods
      extend ActiveSupport::Concern

      module ClassMethods
        def define_attribute_methods(klass)
          attrs = attribute_fields(klass)
          attrs.each do |attr_name|
            class_eval do
              define_method "#{klass.to_s.downcase}_#{attr_name}" do
                @article.send(attr_name)
              end
            end
          end
          @attribute_methods_generated = true
        end

        def attribute_methods_generated?
          @attribute_methods_generated ||= false
        end

        def attribute_fields(klass)
          klass.fields.keys.delete_if { |field| field =~ /(.*)(_ids?)$/ || field =~ /^_(.*)/ }
        end
      end
    end
  end
end
