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
      
      def respond_to?(method)
        method_name = method.to_s
        if method_name =~ /^(nav_children)_(.*)$/ && @current_site.page_by_title($1)
          return true
        elsif method_name =~ /^(nav_siblings_and_self)_(.*)/ && @current_site.page_by_title($1)
          return true
        else
          super
        end
      end

      def method_missing(method, *arguments, &block)
        method_name = method.to_s
        case method_name
        when /^(nav_children)_(.*)/
          self.class.define_attribure_method(method_name, $1, $2)
        when /^(nav_siblings_and_self)_(.*)/
          self.class.define_attribure_method(method_name, $1, $2)
        else
          super
        end
        
        if self.class.attribute_method_generated?(method)
          self.send(method)
        else
          super
        end
      end
    end
  end
end
