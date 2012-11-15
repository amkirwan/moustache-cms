module MoustacheCms
  module Mustache
    module ArticleTags

      # This tag will display the list of articles paginated. From within the paginated list you can
      # access all the properties of an article to display in your view. Using this tag will only show
      # the paginated list of articles so you will also want to define an {{ article }} 
      # You will most likely want to use this tag in conjunction with the
      # {{{paginate_articles}}} tag
      def articles_list_for(name)
        if @article.nil?
          find_articles(name) 
          articles_to_list
        end
      end

      # You will use a list of articles for the collection or it will return a single article
      # if the url matches a permalink in your collection. This tag will be usefull if you display your 
      # articles the same as in the list view and the permalink view. If you want to display your articles
      # between the paginated list of articles and an individual artcile then you will want to use the 
      # You will most likely want to use this tag in conjunction with the
      # {{{paginate_articles}}} tag
      def articles_for(name)
        @article.nil? ? find_articles(name) : (@articles = [@article])
        articles_to_list
      end

      def article
        @article
      end

      # process the article contents with the filter
      def article_content
        process_with_filter(@article)  
      end
      
      def paginate
        paginator(nil)
      end
      
      def paginate_articles
        lambda do |text|
          paginator(text)
        end
      end

      def link_to_next_page
        lambda do |text|
          paginate_next(text)
        end
      end

      def link_to_previous_page
        lambda do |text|
          paginate_previous(text)
        end
      end

      def page_entries_info
        unless @articles.nil?
          engine = gen_haml('page_entries_info.haml')
          context = action_view_context(File.join("#{Rails.root}", 'lib', 'moustache_cms', 'mustache', 'templates'))
          engine.render(context, {:articles => @articles})
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
        when /^(articles_list_for)_(.*)/
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

      def paginator(text=nil)
        if @article.nil?  
          options = text.nil? ? {} : parse_text(text)
          engine = gen_haml('paginate_articles.haml')
          context = action_view_context(File.join("#{Rails.root}", 'lib', 'moustache_cms', 'mustache', 'templates'))
          engine.render(context, {:articles => @articles, :options => options})
        end
      end

      def paginate_next(text)
        if @article.nil?  
          options = parse_text(text)
          if options['link_text']
            link_text = options['link_text']
            options.delete('link_text')
          else
            link_text = 'Next Page'
          end
          engine = gen_haml('paginate_next.haml')
          context = action_view_context(templates_dir)
          engine.render(context, {:articles => @articles, :link_text => link_text, :options => options})
        end
      end

      def paginate_previous(text)
       if @article.nil?  
          options = parse_text(text)
          if options['link_text']
            link_text = options['link_text']
            options.delete('link_text')
          else
            link_text = 'Previous Page'
          end
          engine = gen_haml('paginate_previous.haml')
          context = action_view_context(File.join("#{Rails.root}", 'lib', 'moustache_cms', 'mustache', 'templates'))
          engine.render(context, {:articles => @articles, :link_text => link_text, :options => options})
        end 
      end

      def articles_to_list
        @articles_list = [] 
        @articles.each do |article|
          if article.published?
            # hash = {}
            #attrs = self.class.attribute_fields(Article)
            #attrs.each do |attr_name|
              # hash[attr_name] = article.send(attr_name)
            # end
            # hash['created_by'] = article.created_by.attributes
            # process_article_with_filter(article, hash)
            # @articles_list << hash
            @articles_list << article
          end
        end
        @articles_list
      end

      def find_articles(name)
        @articles = @current_site.articles_by_collection_name(name.to_s).desc(:published_on).page(params[:page]).per(MoustacheCms::Application.config.default_per_page)
      end

      def process_article_with_filter(article, hash)
        to_process = %w(content)
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
