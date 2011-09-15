module HandlebarCms
  module Mustache
    module Head 
      
      # -- Title ---- 
      def title
        engine = gen_haml(%{%title= title})
        engine.render(nil, {:title => @page.title})
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
        engine = gen_haml(%{%meta{:name => "title", :content => title }})
        engine.render(nil, {:title => @page.meta_data["title"]})
      end
    
      def meta_keywords
        engine = gen_haml(%{%meta{:name => "keywords", :content => keywords}})
        engine.render(nil, {:keywords => @page.meta_data["keywords"]})
      end
    
      def meta_description
        engine = gen_haml(%{%meta{:name => "description", :content => description}})
        engine.render(nil, {:description => @page.meta_data["description"]})
      end
    
      def meta_data
        engine = gen_haml(%{- page.meta_data.each_pair do |k, v|
          %meta{:name => k, :content => v}
        })
        engine.render(nil, {:page => @page})
      end    
      alias_method :meta_all, :meta_data
      
      private 
        def css_tag(file)
          tag = %(<link rel="stylesheet" href="#{file.asset.url}") 
          tag += %(#{file.html_options}) if !file.html_options.blank?
          tag += %( >\n)
        end
    end
  end
end
