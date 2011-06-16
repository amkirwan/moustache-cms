module Etherweb
  module Mustache
    module MetaHead    
      def meta_title
        %(<meta #{@page.meta_data["title"]} />)
      end
    
      def meta_keywords
        %(<meta #{@page.meta_data["keywords"]} />)
      end
    
      def meta_description
        %(<meta #{@page.meta_data["description"]} />)
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
end