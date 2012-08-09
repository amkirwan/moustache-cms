module MoustacheCms
  module Mustache
    module ArticleTags

      def articles_for(name)
        @articles = @current_site.articles_by_collection_name(name.to_s).desc(:created_at)
        list = []
        @articles.each do |article|
          @article = article
          if article.published?
            list <<  { "title" => article_title, "subheading" => article_subheading }
          end
        end
        list
      end

      def method_missing(method_id, *arguments, &block)
        if (method_id =~ /^(article_)(.*)$/) && @article.respond_to?($2)
          if $2 =~ /(.*)(_id)/
            super
          else
            method = method_id.to_s.gsub(/^(article_)(.*)$/) { $2 }
            class_eval do 
              define_method method_id do 
                @article.send(method)
              end
            end
            self.send(method_id)
          end
        else
          super
        end
      end

    end
  end
end
