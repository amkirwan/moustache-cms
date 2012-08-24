module MoustacheCms
  module Mustache
    module AttributeMethods
      extend ActiveSupport::Concern

      module ClassMethods
        def define_attribute_method(method_name, calling_method, name)
          class_eval do
            define_method method_name do
              self.send(calling_method, name)
            end
          end
          generated_methods << method_name
        end

        def define_snippet_method(method_name, name)
          class_eval do
            define_method method_name do
              snippet_method(name)
            end  
          end
          generated_methods << method_name
        end

        def define_page_part_method(method_name, name)
          class_eval do
            define_method method_name do
              page_part_method(name)
            end
          end
          generated_methods << method_name
        end

        def generated_methods
          @generated_methods ||= []  
        end

        def attribute_fields(klass)
          klass.fields.keys.delete_if { |field| field =~ /(.*)(_ids?)$/ || field =~ /^_(.*)/ }
        end
      end
    end
  end
end
