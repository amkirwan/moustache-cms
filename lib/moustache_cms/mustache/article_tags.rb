module MoustacheCms
  module Mustache
    module ArticleTags

      def articles_list_for(name)
        find_articles(name)
        articles_to_list
      end

      def articles_for(name)
        # assign article if this is a permalink
        @article.nil? ? find_articles(name) : (@articles = [@article])
        articles_to_list
      end

      def article
        @article
      end

      def paginate_articles
        lambda do |text|
          if @article.nil?  
            options = parse_text(text)
            engine = gen_haml('paginate_articles.haml')
            context = action_view_context("#{Rails.root}/lib/moustache_cms/mustache/templates")
            engine.render(context, {:articles => @articles, :options => options})
          end
        end
      end

      def respond_to?(method)
        method_name = method.to_s
        if method_name =~ /^articles_list_for_(.*)/ && @current_site.article_collection_by_name($1)
          return true
        elsif method_name =~ /^articles_for_(.*)/ && @current_site.article_collection_by_name($1)
          return true
        else
          super
        end
      end

      def method_missing(method, *arguments, &block)
        method_name = method.to_s
        case method_name
        when /^(articles_list)_for_(.*)/
          self.class.define_attribute_method(method_name, $1, $2)
        when /^(articles_for)_(.*)/
          self.class.define_attribute_method(method_name, $1, $2)
        end

        if self.class.generated_methods.include?(method)
          self.send(method)
        else
          super
        end
      end

     
      private

      def articles_to_list
        @articles_list = [] 
        @articles.each do |article|
          if article.published?
            hash = {}
            attrs = self.class.attribute_fields(Article)
            attrs.each do |attr_name|
              hash[attr_name] = article.send(attr_name)
            end
            hash['created_by'] = article.created_by.attributes
            process_article_with_filter(article, hash)
            @articles_list << hash
          end
        end
        @articles_list
      end

      def find_articles(name)
        @articles = @current_site.articles_by_collection_name_desc(name.to_s).page(params[:page]).per(MoustacheCms::Application.config.default_per_page)  
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

    end
  end
end
