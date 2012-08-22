module MoustacheCms
  module Mustache
    module ArticleTags

      def articles_for(name)
        # assign article if this is not a permalink
        if @controller.params[:year].nil?
          @articles = @current_site.articles_by_collection_name_desc(name.to_s).page(params[:page]).per(MoustacheCms::Application.config.default_per_page)  
        else
          @articles = []
        end   
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
            list << hash
          end
        end
        list
      end

      def article
        @article
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
          unless @articles.empty?
            options = parse_text(text)
            context = ActionView::Base.new("#{Rails.root}/lib/moustache_cms/mustache/templates", {}, @controller, nil)
            context.class_eval do
              include Rails.application.routes.url_helpers
            end
            engine = gen_haml('paginate_articles.haml')
            engine.render(context, {:articles => @articles, :options => options})
          end

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
