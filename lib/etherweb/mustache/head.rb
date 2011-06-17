module Etherweb
  module Mustache
    module Head 
      
      # -- Title ---- 
      def title
        %(<title>#{@page.title}</title>\n)
      end   
      
      # -- Css ----
      def stylesheet(name)
        if name == "all"
          css_files = ""
          @current_site.css_files.each do |file|
            css_files += %(<link rel="stylesheet" href="#{file.asset.url}">\n)
          end
          css_files
        else
          %(<link rel="stylesheet" href="#{@current_site.css_file_by_name(name).asset.url}">\n)
        end
      end
      
      # -- Meta Tags ----
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