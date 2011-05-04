module Etherweb
  module MetaHead
    
    def meta_title
      %(<meta name="title" content="#{@page.meta_data["title"]}")
    end
    
    def meta_keywords
      %(<meta name="keywords" content="#{@page.meta_data["keywords"]}")
    end
    
    def meta_description
      %(<meta name="description" content="#{@page.meta_data["description"]}")
    end
    
    def meta_data
      meta_data = ""
      @page.meta_data.each_pair do |k, v|
        meta_data += %(<meta name="#{k}" content="#{v}">\n)
      end
      meta_data
    end
    
  end
end