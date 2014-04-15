module MoustacheCms
  module Mustache
    module MediaTags

      %w{favicon_link_tag asset_path}.each do |method|
        define_method method do
          lambda do |text|
            hash = parse_text(text)
            hash['source'] = hash['name'] if hash.has_key?('name')
            options = hash.reject { |k,v| k == 'name' || k == 'source' }

            engine = Haml::Engine.new("= #{method} source, options")
            engine.render(action_view_context, {source: hash['source'], options: options.symbolize_keys})
          end
        end
      end

      %w{image_path image_alt audio_path video_path font_path javascript_path stylesheet_path
         audio_tag video_tag javascript_include_tag stylesheet_link_tag}.each do |method| define_method method do 
          lambda do |text|
            hash = parse_text(text)
            hash['source'] = hash['name'] if hash.has_key?('name')

            engine = Haml::Engine.new("= #{method} source")
            engine.render(action_view_context, {source: hash['source']})
          end
        end
      end

      def image_tag 
        lambda do |text|
          hash = parse_text(text)
          hash['source'] = hash['name'] if hash.has_key?('name')
          options = hash.reject { |k,v| k == 'name' || k == 'source' }
          options = options.symbolize_keys

          engine = Haml::Engine.new("= image_tag source, options")
          if hash.has_key?('collection_name')
            # for site asset images
            image = find_image(hash)
            src = get_image_src(hash, image)
            engine.render(action_view_context, {source: src, options: options})
          elsif hash.has_key?('theme_collection_name')
            # old way to get theme images
            src = hash['theme_collection_name'] + '/' + hash['source']
            engine.render(action_view_context, {source: src, options: options})
          else
            # theme images
            engine.render(action_view_context, {source: hash['source'], options: options})
          end
        end
      end

      def auto_discovery_link_tag 
        lambda do |text|
          hash = parse_text(text)
          type = hash.delete('type') { |k| 'rss' }
          url_options = hash.except('title', 'type', 'rel').symbolize_keys 
          tag_options = hash.slice('title', 'type', 'rel').symbolize_keys
          engine = Haml::Engine.new("= auto_discovery_link_tag type, url_options, tag_options")
          engine.render(action_view_context, {type: type, url_options: url_options, tag_options: tag_options})
        end
      end

      # depricated method for loading image use image_tag
      def image
        lambda do |text|
          begin 
            hash = parse_text(text)
            image = find_image(hash)
            src = get_image_src(hash, image)

            unless image.nil?
              engine = gen_haml('image.haml')
              engine.render(nil, {:src => src, :id => hash['id'], :class_name => hash['class'], :alt => hash['alt'], :title => hash['title'], :itemprop => hash['itemprop'], :height => hash['height'], :width => hash['width']})
            end
          rescue NoMethodError => e
            Rails.logger.error "#{e} could not find image with the params: #{text}"
          end
        end
      end

      # depricated method use image_path
      def image_src
        lambda do |text|
          hash = parse_text(text)
          image = find_image(hash)
          image.asset_digest_path
        end
      end
      alias_method :media_url, :image_src

      private 

      def find_image(hash)
        if hash.key?('source')
          @current_site.site_asset_by_name(hash['collection_name'], hash['source'])
        else
          @current_site.site_asset_by_name(hash['collection_name'], hash['name'])
        end
      end

      def get_image_src(hash, image)
        if hash['fingerprint'] == 'false'
          src = image.asset.url
        else
          src = image.asset_digest_path
        end
      end

    end
  end
end

