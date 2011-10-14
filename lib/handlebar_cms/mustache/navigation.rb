module HandlebarCms
  module Mustache
    module Navigation
      
      def nav_child_pages
        engine = gen_haml('nav_child_pages')
        engine.render(TagHelper.instance, {:request => @request, :parent_page => @page})  
      end   
      
      
      def nav_children(page_name)
        engine = gen_haml('nav_children')
        engine.render(TagHelper.instance, {:request => @request, :parent_page => @current_site.page_by_name(page_name)})  
      end
 

      def nav_siblings(page_name)
        engine = gen_haml('nav_siblings')
        engine.render(TagHelper.instance, {:request => @request, :page => @current_site.page_by_name(page_name)})
      end
      
    end
  end
end
