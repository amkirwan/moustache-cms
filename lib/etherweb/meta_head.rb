module Etherweb
  module MetaHead
  
    def meta_title
      %(<meta name="DC.title" lang="en" content="#{@page.meta_title}">)
    end
    
    def meta_keywords
      %(<meta name="keywords" content="#{@page.meta_keywords}">)
    end
    
    def meta_description
      %(<meta name="description" content="#{@page.meta_description}")
    end
  end
end