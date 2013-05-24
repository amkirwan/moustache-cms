module MoustacheCms
  module Mustache
    module NavigationTags

      def nav_primary
        engine = gen_haml('nav_primary.haml')
        engine.render(action_view_helpers_context, {:request => @request, :homepage => @current_site.page_by_full_path('/')})  
      end
      
      def nav_child_pages(page_title=nil)
        engine = gen_haml('nav_children.haml')
        if page_title
          engine.render(action_view_helpers_context, {:request => @request, :parent_page => @current_site.page_by_title(page_title) })  
        else
          engine.render(action_view_helpers_context, {:request => @request, :parent_page => @page})  
        end
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
        if method_name =~ /^(nav_children)_(.*)$/ && @current_site.page_by_title($2)
          return true
        elsif method_name =~ /^(nav_child_pages)_(.*)$/ && @current_site.page_by_title($2)
          return true
        elsif method_name =~ /^(nav_siblings_and_self)_(.*)/ && @current_site.page_by_title($2)
          return true
        else
          super
        end
      end

      def method_missing(method, *arguments, &block)
        method_name = method.to_s
        case method_name
        when /^(nav_child_pages)_(.*)/  
          self.class.define_attribute_method(method_name, $1, $2)
        when /^(nav_children)_(.*)/
          self.class.define_attribute_method(method_name, $1, $2)
        when /^(nav_siblings_and_self)_(.*)/
          self.class.define_attribute_method(method_name, $1, $2)
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
