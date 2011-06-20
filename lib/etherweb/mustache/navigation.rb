module Etherweb
  module Mustache
    module Navigation
      
      def format(value)
        value.downcase.gsub(/\s/,'_')
      end
            
      def nav_child_pages(css_class="nav")   
        nav = %(<ul class="#{css_class}">)
        @page.children.each do |page|
          nav += %(<li>)
          nav += %(<a href="http://#{@request.host.downcase}#{page.full_path}" id="#{format(page.title)}" title="#{foramt(page.title)}">#{page.title}</a>)
          nav += %(</li>)
        end
        nav += %(</ul>)
      end   
      
      def nav_children_and_self(page_name)
        parent_page = @current_site.page_by_name(page_name)
        nav = %(<ul class="nav nav_#{page_name}">)
        nav += %(<li><a href="http://#{@request.host}#{parent_page.full_path}" id="#{format(parent_page.title)}" title="#{format(parent_page.title)}">#{parent_page.title}</a></li>)
        parent_page.children.each do |page|
          nav += %(<li>)
          nav += %(<a href="http://#{@request.host}#{page.full_path}" id="#{format(page.title)}" title="#{format(page.title)}">#{page.title}</a>)
          nav += %(</li>)
        end
        nav += %(</ul>)
      end
      
      def nav_children(page_name)
        parent_page = @current_site.page_by_name(page_name)
        nav = %(<ul class="nav nav_#{page_name}">)
        parent_page.children.each do |page|
          nav += %(<li>)
          nav += %(<a href="http://#{@request.host}#{page.full_path}" id="#{format(page.title)}" title="#{format(page.title)}">#{page.title}</a>)
          nav += %(</li>)
        end
        nav += %(</ul>)
      end
      
      def nav_siblings_and_self(page_name)
        page_sibling = @current_site.page_by_name(page_name)
        nav = %(<ul class="nav nav_#{page_name}">)
        page_sibling.siblings_and_self.each do |page|
          nav += %(<li>)
          nav += %(<a href="http://#{@request.host}#{page.full_path}" id="#{format(page.title)}" title="#{format(page.title)}">#{page.title}</a>)
          nav += %(</li>)
        end
        nav += %(</ul>)
      end
      
      def nav_siblings(page_name)
        page_sibling = @current_site.page_by_name(page_name)
        nav = %(<ul class="nav nav_#{page_name}">)
        page_sibling.siblings.each do |page|
          nav += %(<li>)
          nav += %(<a href="http://#{@request.host}#{page.full_path}" id="#{format(page.title)}" title="#{format(page.title)}">#{page.title}</a>)
          nav += %(</li>)
        end
        nav += %(</ul>)
      end
               
    end
  end
end