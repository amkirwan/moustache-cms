module MoustacheCms
  module Mustache
    module MediaTags

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

      def image_src
        lambda do |text|
          hash = parse_text(text)
          image = find_image(hash)
          src = get_image_src(hash, image)
        end
      end
      alias_method :media_url, :image_src

      def image_tag
        lambda do |text|
          hash = parse_text(text)
          engine = gen_haml('image_tag.haml')
          engine.render(nil, {:name => hash['name'], :id => hash['id'], :class_name => hash['class'], :alt => hash['alt'], :title => hash['title'], :itemprop => hash['itemprop'], :height => hash['height'], :width => hash['width']})
        end
      end

      private 

      def find_image(hash)
        if hash['theme_collection_name']
          @current_site.theme_image_file_by_name(hash['theme_collection_name'], hash['name'])
        else
          @current_site.site_asset_by_name(hash['collection_name'], hash['name'])
        end
      end

      def get_image_src(hash, image)
        if hash['fingerprint'] == 'false'
          src = image.asset.url
        else
          src = image.url_md5 
        end
      end

    end
  end
end

