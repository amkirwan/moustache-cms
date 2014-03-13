module MoustacheCms
  module Mustache
    module HeadTags 
      
      # -- Css ----
      def stylesheet
        lambda do |text|
          hash = parse_text(text) #Hash[*text.scan(/(\w+):([&.\w\s\-]+)/).to_a.flatten]
          attributes = style_attributes.merge(hash)
          file = @current_site.theme_css_file_by_name(hash['theme_name'], hash['name'])
          unless file.nil?
            set_default_attribute_values(attributes, file)
            set_link_attributes(attributes, file)
            engine = gen_haml('stylesheet.haml')
            engine.render(nil, attributes)
          end
        end
      end

      def stylesheets
        @css_files = @current_site.css_files
        haml_render = ""
        @css_files.each do |file|
          attributes = style_attributes
          set_default_attribute_values(attributes, file)
          set_link_attributes(attributes, file)
          engine = gen_haml('stylesheet.haml')
          haml_render += engine.render(nil, attributes)
        end
        haml_render
      end
      alias_method :stylesheets_all, :stylesheets

      def stylesheet_link_tag
        lambda do |text|
          hash = Hash[*text.scan(/(\w+):([&.\w\s\-]+)/).to_a.flatten]
          engine = gen_haml('stylesheet_link_tag.haml')
          engine.render(action_view_context, {:name => "#{MoustacheCms::Application.config.css_path}/#{hash['name'].strip!}"})
        end
      end

      # -- js ---
      def js_file
        lambda do |text|
          hash = Hash[*text.scan(/(\w+):([&.\w\s\-]+)/).to_a.flatten]
          file = @current_site.theme_js_file_by_name(hash['theme_name'], hash['name'])
          unless file.nil?
            engine = gen_haml('javascript.haml')
            engine.render(nil, {:src => file.url_md5})
          end
        end
      end
      
      # -- Meta Tags ----

      def meta_tags_csrf
        engine = gen_haml('meta_tags_csrf.haml')
        engine.render(action_view_context, {:@controller => @controller})
      end
    
      def respond_to?(method)
        method_name = method.to_s
        if method_name =~ /^meta_tag_(.*)/ 
          true
        else
          super
        end
      end

      def method_missing(method, *args, &block)
        method_name = method.to_s
        if method_name =~ /^(meta_tag)_(.*)/
          self.class.define_meta_tag_method(method_name, $2)
        end

        if self.class.generated_methods.include?(method)
          self.send(method)
        else
          super
        end
      end

      private 

        def set_default_attribute_values(attributes, file)
          attributes['href'] = file.url_md5
          attributes['rel'] = 'stylesheet'
        end

        def set_link_attributes(attributes, file)
          file.custom_fields.each do |field|
            attributes[field.name] = field.content
          end
        end

        def style_attributes
          {'href' => nil, 'type' => nil, 'media' => nil, 'rel' => nil, 'title' => nil, 'charset' => nil} 
        end
        
        def meta_tag_name(name)
          meta_tag = @page.meta_tags.where(:name => name).first
          meta_tag = @current_site.meta_tags.where(:name => name).first if meta_tag.nil? || meta_tag.content.empty?
          meta_tag = "" if meta_tag.nil?
          meta_tag
        end

    end
  end
end
