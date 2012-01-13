module HandlebarCms
  module Mustache
    module Head 
      
      # -- Title ---- 
      def title
        engine = Haml::Engine.new(%{%title= title})
        engine.render(nil, {:title => @page.title})
      end   
      
      # -- Css ----
      def stylesheet
        lambda do |text|
          theme_name, css_name = text.split(',').each { |arg| arg.strip! }
          attributes = style_attributes
          file = @current_site.css_file_by_name(theme_name, css_name)
          set_default_attribute_values(attributes, file)
          set_link_attributes(attributes, file)
          engine = gen_haml('stylesheet')
          engine.render(nil, attributes)
        end
      end

      def stylesheets
        @css_files = @current_site.css_files
        haml_render = ""
        @css_files.each do |file|
          attributes = style_attributes
          set_default_attribute_values(attributes, file)
          set_link_attributes(attributes, file)
          engine = gen_haml('stylesheet')
          haml_render += engine.render(nil, attributes)
        end
        haml_render
      end
      alias_method :stylesheets_all, :stylesheets

      # -- js ---
      def js_file
        lambda do |text|
          theme_name, js_name = text.split(',').each { |arg| arg.strip! }
          file = @current_site.js_file_by_name(theme_name, js_name)
          engine = gen_haml('javascript')
          engine.render(nil, {:src => file.url_md5})
        end
      end
      
      # -- Meta Tags ----
      def meta_tag
        lambda do |text|
          engine = gen_haml('meta_tag')
          engine.render(nil, {:name => name, :content => meta_tag_name(text).content})
        end
      end
    
      def page_meta_tags
        meta_tags = 
        engine = gen_haml('meta_tags')
        engine.render(nil, {:page => @page})
      end    
      
      private 
        def meta_tag_with_name(name)
          engine = gen_haml('meta_tag')
          engine.render(nil, {:name => name, :content => meta_tag_name(name).content})
        end

        def set_default_attribute_values(attributes, file)
          attributes['href'] = file.url_md5
          attributes['rel'] = 'stylesheet'
        end

        def set_link_attributes(attributes, file)
          attributes.each_key do |k|
            attr = file.tag_attrs.where('name' => k).first
            attributes[k] = attr.value unless attr.nil?
          end
        end

        def style_attributes
          {'href' => nil, 'type' => nil, 'media' => nil, 'rel' => nil, 'title' => nil, 'charset' => nil} 
        end
        
        def meta_tag_name(name)
          meta_tag = @page.meta_tags.where(:name => name).first
          meta_tag = @current_site.meta_tags.where(:name => name).first if meta_tag.nil?
          meta_tag = "" if meta_tag.nil?
          meta_tag
        end

    end
  end
end
