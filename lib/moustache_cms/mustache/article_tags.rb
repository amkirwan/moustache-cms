module MoustacheCms
  module Mustache
    module ArticleTags

      def articles_for(name)
        @articles = @current_site.articles_by_collection_name_desc(name.to_s).page(@controller.params[:page]).per(3)
        list = []
        @articles.each do |article|
          if article.published?
            hash = {}
            attrs = self.class.attribute_fields(Article)
            attrs.each do |attr_name|
              hash[attr_name] = article.send(attr_name)
            end
            hash['created_by'] = article.created_by.attributes
            process_article_with_filter(article, hash)
            process_with_filter(article)
            list << hash
          end
        end
        list
      end


      def process_article_with_filter(article, hash)
        to_process = %w(subheading content)
        case article.filter_name  
        when "markdown"
          to_process.each { |part| hash[part] = process_with_markdown(hash[part]) }
        when "textile"
          to_process.each { |part| hash[part] = process_with_textile(hash[part]) }
        end
      end

      def paginate_articles
        lambda do |text|
          options = parse_text(text)
          context = ActionView::Base.new("#{Rails.root}/lib/moustache_cms/mustache/templates", {}, @controller, nil)
          context.class_eval do
            include Rails.application.routes.url_helpers
          end
          engine = gen_haml('paginate_articles.haml')
          engine.render(context, {:articles => @articles, :options => options})

        end
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
