module MoustacheCms
  module Mustache
    module MediaTags

      def image
        lambda do |text|
          hash = parse_text(text)

          if hash['theme_collection_name']
            image = @current_site.theme_image_file_by_name(hash['theme_collection_name'], hash['name'])
          else
            image = @current_site.site_asset_by_name(hash['collection_name'], hash['name'])
          end

          if hash['fingerprint'] == 'false'
            src = image.asset.url
          else
            src = image.url_md5 
          end

          unless image.nil?
            engine = gen_haml('image.haml')
            engine.render(nil, {:src => src, :id => hash['id'], :class_name => hash['class'], :alt => hash['alt'], :title => hash['title']})
          end
        end
      end

    end
  end
end

