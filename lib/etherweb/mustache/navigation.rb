module Etherweb
  module Mustache
    module Navigation
      
            
      def nav_child_pages(css_class="nav") 
template = %{
%ul{:class => css_class}
  - parent_page.children.each do |page|
  %li 
  - href = "http://#{@request.host.downcase}" + page.full_path
    %a{:id => page.title.downcase.gsub(/\s/, '_'), :title => page.title, :href => href }= page.title
}        
        engine = gen_haml(template.strip!)
        engine.render(Object.new, {:css_class => css_class, :parent_page => @page})  
      end   
      
      
      
      def nav_children_and_self(page_name)       
template = %{
%ul{:classs => "nav nav_#{page_name}"}
  - href = "http://#{@request.host.downcase}" + parent_page.full_path
  %li
    %a{:id => parent_page.title.downcase.gsub(/\s/, '_'), :title => parent_page.title, :href => href }= parent_page.title
    - parent_page.children.each do |page|
      %li
        - href = "http://#{@request.host.downcase}" + page.full_path
        %a{:id => page.title.downcase.gsub(/\s/, '_'), :title => page.title, :href => href }= page.title
}
        engine = gen_haml(template.strip!)
        engine.render(Object.new, {:page_name => page_name, :parent_page => @current_site.page_by_name(page_name)})
      end
      
      
      
      def nav_children(page_name)
template = %{
%ul{:class => "nav nav_#{page_name}"}
  - parent_page.children.each do |page|
  %li
  - href = "http://#{@request.host.downcase}" + page.full_path
    %a{:id => page.title.downcase.gsub(/\s/, '_'), :title => page.title, :href => href }= page.title
}
        engine = gen_haml(template.strip!)
        engine.render(Object.new, {:page_name => page_name, :parent_page => @current_site.page_by_name(page_name)})
      end
 

      def nav_siblings_and_self(page_name)
template = %{
%ul{:class => "nav nav_#{page_name}"}
  - sibling.siblings_and_self.each do |page|
  %li
  - href = "http://#{@request.host.downcase}" + page.full_path
    %a{:id => page.title.downcase.gsub(/\s/, '_'), :title => page.title, :href => href }= page.title   
}

        engine = gen_haml(template.strip!)
        engine.render(Object.new, {:page_name => page_name, :sibling => @current_site.page_by_name(page_name)})
      end
      
      
      
      def nav_siblings(page_name)
template = %{
%ul{:class => "nav nav_#{page_name}"}
  - sibling.siblings.each do |page|
    %li
      - href = "http://#{@request.host.downcase}" + page.full_path
      a{:id => page.title.downcase.gsub(/\s/, '_'), :title => page.title, :href => href }= page.title
}

        engine = gen_haml(template.strip!)
        engine.render(Object.new, {:page_name => page_name, :sibling => @current_site.page_by_name(page_name)})
      end
      
      
                    
    end
  end
end