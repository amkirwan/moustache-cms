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
            css_files += css_tag(file)
          end
          css_files
        else                                    
          file = @current_site.css_file_by_name(name)
          css_tag(file)
        end
      end
      
      # -- Meta Tags ----
      def meta_title
        %(<meta #{@page.meta_data["title"]}>)
      end
    
      def meta_keywords
        %(<meta #{@page.meta_data["keywords"]}>)
      end
    
      def meta_description
        %(<meta #{@page.meta_data["description"]}>)
      end
    
      def meta_data
        meta_data = ""
        @page.meta_data.each_pair do |k, v|
          meta_data += %(<meta name="#{k}" content="#{v}">\n)
        end
        meta_data
      end    
      
      private 
        def css_tag(file)
          tag = %(<link rel="stylesheet" href="#{file.asset.url}") 
          tag += %(#{file.html_options}) if !file.html_options.blank?
          tag += %( >\n)
        end
    end
  end
end