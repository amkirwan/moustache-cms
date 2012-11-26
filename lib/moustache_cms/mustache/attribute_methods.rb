module MoustacheCms
  module Mustache
    module AttributeMethods
      extend ActiveSupport::Concern

      module ClassMethods
        def define_attribute_method(method_name, calling_method, name)
          class_eval <<-EOT, __FILE__, __LINE__ + 1
            define_method method_name do
              self.send(calling_method, name)
            end
          EOT
          add_generated_method(method_name) 
        end

        def define_snippet_method(method_name, name)
          class_eval <<-EOT, __FILE__, __LINE__ + 1
            define_method method_name do
              snippet_method(name)
            end  
          EOT
          add_generated_method(method_name) 
        end

        def define_page_part_method(method_name, name)
          class_eval <<-EOT, __FILE__, __LINE__ + 1
            define_method method_name do
              page_part_method(name)
            end
          EOT
          add_generated_method(method_name) 
        end

        def define_meta_tag_method(method_name, name)
          class_eval <<-EOT, __FILE__, __LINE__ + 1
            define_method method_name do
              engine = gen_haml('meta_tag.haml')
              engine.render(nil, {:name => name, :content => meta_tag_name(name).content})
            end
          EOT
          add_generated_method(method_name) 
        end

        def generated_methods
          @generated_methods ||= []  
        end

        def attribute_method_generated?(method)
          self.generated_methods.include?(method.to_sym)   
        end

        def add_generated_method(method_name)
          self.generated_methods << method_name.to_sym
        end

      end

    end
  end
end
