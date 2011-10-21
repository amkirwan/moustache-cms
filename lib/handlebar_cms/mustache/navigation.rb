module HandlebarCms
  module Mustache
    module Navigation
      
      def nav_child_pages
        engine = gen_haml('nav_child_pages')
        engine.render(TagHelper.instance, {:request => @request, :parent_page => @page})  
      end   
      
      
      def nav_children(page_tag)
        engine = gen_haml('nav_children')
        engine.render(TagHelper.instance, {:request => @request, :parent_page => @current_site.page_by_render_tag(page_tag)})  
      end
 

      def nav_siblings_and_self(page_tag)
        engine = gen_haml('nav_siblings_and_self')
        engine.render(TagHelper.instance, {:request => @request, :page => @current_site.page_by_render_tag(page_tag)})
      end
      
    end
  end
end
