module Etherweb
  module Mustache
    module Navigation
            
      def nav_child_pages(css_class="nav")
        nav = %(<ul class="#{css_class}">)
        @page.children.each do |page|
          nav += %(<li>)
          nav += %(<a href="http://#{@request.host.downcase}#{page.full_path}" id="#{page.title}" title="#{page.title}">#{page.title}</a>)
          nav += %(</li>)
        end
        nav += %(</ul>)
      end            
    end
  end
end