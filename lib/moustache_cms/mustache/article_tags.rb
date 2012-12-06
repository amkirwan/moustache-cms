require 'builder'

module MoustacheCms
  module Mustache
    module ArticleTags

      def error_messages
        unless @comment.nil?
          engine = gen_haml('error_messages.haml')
          engine.render(action_view_context, {target: @comment, :@controller => @controller})
        else
      end

      def flash_message
        
      end

      # This tag will render a page part named either '_articles' or '_article'. This allows you to render a page either as the collection of articles or an article with the permalink.
      def articles_or_article
        part = @article.nil? ? @page.page_parts.where(name: '_articles').first : @page.page_parts.where(name: '_article').first
        process_with_filter(part)
      end

      # This tag will display the list of articles paginated. From within the paginated list you can
      # access all the properties of an article to display in your view. Using this tag will only show
      # the paginated list of articles so you will also want to define an {{ article }} 
      # You will most likely want to use this tag in conjunction with the
      # {{{paginate_articles}}} tag
      def articles_for(name)
        find_articles(name) 
        articles_to_list
      end

      # This tag will find the page part named feed and process it 
      def feed_for(name)
        find_articles(name) 
        articles_to_list
        feed = @page.page_parts.where(name: 'feed').first
        process_with_filter(feed)    
      end

      # Returns the latest updated at date in xmlschema format for the articles that are published .
      def feed_updated
        @articles_published.first.updated_at.xmlschema if @articles_published.length > 0
      end

      def form_for_comment
        lambda do |text|
          hash = parse_text(text) 
          options = { 'id' => nil, 'class' => nil }.merge(hash)
          engine = gen_haml('form_for_comment.haml')
          engine.render(action_view_context, {article: @article, comment: Comment.new, options: options, :@controller => @controller})
        end
      end

      # Returns a atom feed for the articles published
      def generate_atom_feed
        xml = ""
        builder = Builder::XmlMarkup.new
        @articles_published.each do |article|
          content = process_with_filter(article)
          xml = builder.entry do |b|
            b.title(type: "html") { |t| t.cdata!(article.title) }
            b.author { |a| a.name(article.authors.first.full_name) }
            b.link(rel: 'alternate', type: 'text/html', href: full_request(article.permalink))
            b.id(full_request(article.permalink))
            b.updated(article.updated_at.xmlschema)
            b.published(article.published_on.xmlschema)
            b.content(type: "html") { |c| c.cdata!(content) }
          end
        end
        { xml: xml }
      end

      def article
        @article
      end

      def articles
        @articles
      end

      def articles_published
        @articles_published
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
          context = action_view_context
          engine.render(context, {:articles => @articles})
        end
      end

      def respond_to?(method)
        method_name = method.to_s
        if method_name =~ /^articles_for_(.*)/ && @current_site.article_collection_by_name($1)
          return true
        elsif method_name =~ /^feed_for_(.*)/ && @current_site.article_collection_by_name($1)
          return true
        else
          super
        end
      end

      def method_missing(method, *arguments, &block)
        method_name = method.to_s
        case method_name
        when /^(articles_for)_(.*)/
          self.class.define_attribute_method(method_name, $1, $2)
        when /^(feed_for)_(.*)/
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
          context = action_view_context
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
          context = action_view_context
          engine.render(context, {:articles => @articles, :link_text => link_text, :options => options})
        end 
      end

      def articles_to_list
        @articles_published = [] 
        @articles.each do |article|
          if article.published?
            @articles_published << article
          end
        end
        @articles_published
      end

      def find_articles(name)
        @articles = @current_site.articles_by_collection_name(name.to_s).desc('current_state.time').page(params[:page]).per(MoustacheCms::Application.config.default_per_page)
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
