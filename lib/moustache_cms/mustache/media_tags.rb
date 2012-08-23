module MoustacheCms
  module Mustache
    module MediaTags

      def image
        lambda do |text|
          hash = parse_text(text)
          image = @current_site.site_asset_by_name(hash['collection_name'], hash['name'])
          unless image.nil?
            engine = gen_haml('image.haml')
            engine.render(nil, {:src => image.url_md5, :id => hash['id'], :class_name => hash['class'], :alt => hash['alt'], :title => hash['title']})
          end
        end
      end

    end
  end
end

