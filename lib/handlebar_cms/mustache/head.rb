module HandlebarCms
  module Mustache
    module Head 
      
      # -- Title ---- 
      def title
        engine = Haml::Engine.new(%{%title= title})
        engine.render(nil, {:title => @page.title})
      end   
      
      # -- Css ----
      def stylesheet(name)
        attributes = {'href' => nil, 'type' => nil, 'media' => nil, 'rel' => nil, 'title' => nil, 'charset' => nil} 
        theme_asset_css = @current_site.css_file_by_name(name)
        attributes['href'] = theme_asset_css.asset.url
        attributes['rel'] = 'stylesheet'
        attributes.each_key do |k|
         attr = theme_asset_css.tag_attrs.where('name' => k).first
         attributes[k] = attr.value unless attr.nil?
        end
        engine = gen_haml('stylesheet')
        engine.render(nil, attributes)
      end

      def stylesheets
        attributes = {'href' => nil, 'type' => nil, 'media' => nil, 'rel' => nil, 'title' => nil, 'charset' => nil} 
        engine = gen_haml('stylesheet')
        @css_files = @current_site.css_files
        haml_render = ""
        @css_files.each do |file|
          attributes['href'] = file.asset.url
          attributes['rel'] = 'stylesheet'
          attributes.each_key do |k|
           attr = file.tag_attrs.where('name' => k).first
           attributes[k] = attr.value unless attr.nil?
          end
          haml_render += engine.render(nil, attributes)
        end
        haml_render
      end
      alias_method :stylesheets_all, :stylesheets
      
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
        def css_tag(file, attr)
          content_tag :link, :rel => attr['rel'], :href => attr['href'], :type => attr['type'], :media => attr['media'], :title => attr['title'], :charset => attr['charset']
        end

        def meta_tag_name(name)
          !@page.meta_tags.where(:name => name).first.send(:content).blank? ? @page.meta_tags.where(:name => name).first.send(:content) :
          !@current_site.meta_tags.where(:name => name).first.blank? ? @current_site.meta_tags.where(:name => name).first.send(:content) : ''
        end

    end
  end
end
