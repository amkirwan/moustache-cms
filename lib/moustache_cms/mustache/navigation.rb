module MoustacheCms
  module Mustache
    module Navigation

      def nav_primary
        engine = gen_haml('nav_primary.haml')
        engine.render(action_view_helpers_context, {:request => @request, :homepage => @current_site.page_by_full_path('/')})  
      end
      
      def nav_child_pages
        engine = gen_haml('nav_child_pages.haml')
        engine.render(action_view_helpers_context, {:request => @request, :parent_page => @page})  
      end   
      
      
      def nav_children(page_title)
        engine = gen_haml('nav_children.haml')
        engine.render(action_view_helpers_context, {:request => @request, :parent_page => @current_site.page_by_title(page_title)})  
      end
 

      def nav_siblings_and_self(page_title)
        engine = gen_haml('nav_siblings_and_self.haml')
        engine.render(action_view_helpers_context, {:request => @request, :page => @current_site.page_by_title(page_title)})
      end
      
      def respoond_to?(method)
        if method.to_s =~ /^nav_children_(.*)/ && @current_site.page_by_title($1)
          true
        elsif method.to_s =~ /^nav_siblings_and_self_(.*)/ && @current_site.page_by_title($1)
          true
        else
          super
        end
      end

      def method_missing(method_name, *arguments, &block)
        case method_name.to_s
        when /^nav_children_(.*)/
          self.class.define_attribute_method(method_name, :nav_children, $1)
        when /^nav_siblings_and_self_(.*)/ 
          self.class.define_attribure_method(method_name, :nav_siblings_and_self, $1)
        else
          super
        end
        
        if self.class.generated_methods.include?(method_name)
          self.send(method_name)
        else
          super
        end
      end
    end
  end
end
