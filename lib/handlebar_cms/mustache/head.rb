module HandlebarCms
  module Mustache
    module Head 
      
      # -- Title ---- 
      def title
        engine = Haml::Engine.new(%{%title= title})
        engine.render(nil, {:title => @page.title})
      end   
      
      # -- Css ----
=begin
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
=end

      def stylesheet(name)
        file = @current_site.css_file_by_name(name)
        engine = gen_haml('stylesheet')
        engine.render({:file_url => file.asset.url, :media => file.html_options})
      end
      
      # -- Meta Tags ----
      def meta_tag(name)
        engine = gen_haml('meta_tag')
        engine.render(nil, {:name => name, :content => meta_tag_name(name)})
      end
    
      def meta_tags
        engine = gen_haml('meta_tags')
        engine.render(nil, {:page => @page})
      end    
      alias_method :meta_tags_all, :meta_tags
      
      private 
        def css_tag(file)
          tag = %(<link rel="stylesheet" href="#{file.asset.url}") 
          tag += %(#{file.html_options}) if !file.html_options.blank?
          tag += %( >\n)
        end

        def meta_tag_name(name)
          !@page.meta_tags.where(:name => name).first.send(:content).blank? ? @page.meta_tags.where(:name => name).first.send(:content) :
          !@current_site.meta_tags.where(:name => name).first.blank? ? @current_site.meta_tags.where(:name => name).first.send(:content) : ''
        end

    end
  end
end
