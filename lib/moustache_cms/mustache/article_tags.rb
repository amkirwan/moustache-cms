module MoustacheCms
  module Mustache
    module ArticleTags

      def articles_for(name)
        @articles = @current_site.articles_by_collection_name(name.to_s).desc(:created_at)
        list = []
        @articles.each do |article|
          @article = article
          if article.published?
            attrs = self.class.attribute_fields(Article)
            hash = {}
            attrs.each do |attr_name|
              hash[attr_name] = article.send(attr_name)
            end
            list << hash
          end
        end
        Rails.logger.debug "*"*20 + "#{list.inspect}"
        list
      end

      def method_missing(method, *arguments, &block)
        method_name = method.to_s
        unless self.class.attribute_methods_generated?
          self.class.define_attribute_methods(Article)

          if respond_to?(method_name)
            self.send(method_name, *arguments, &block)
          else
            super
          end
        else
          super
        end
      end

    end
  end
end
