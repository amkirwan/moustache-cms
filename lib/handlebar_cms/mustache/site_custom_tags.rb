module HandlebarCms
  module Mustache
    module SiteCustomTags
      def first_article_latest_news
        article = @current_site.article_collections.where(:name => 'news').first.articles.desc(:created_at).first
        {
          "title" => %{<a href="#{article.permalink}">#{article.title}</a>}, 
          "content" => %{#{article.subheading} <a class="read-more" href="#{article.permalink}">Read More &raquo;</a>}
        }
      end


      def first_article_spotlight
        article = @current_site.article_collections.where(:name => 'spotlight').first.articles.desc(:created_at).first
        {
          "title" => %{<a href="#{article.permalink}">#{article.title}</a>}, 
          "content" => %{#{article.subheading} <a class="read-more" href="#{article.permalink}">Read More &raquo;</a>}
        }
      end


      def first_article_upcoming_events
        article = @current_site.article_collections.where(:name => 'events').first.articles.desc(:created_at).first
        {
          "title" => %{<a href="#{article.permalink}">#{article.title}</a>}, 
          "subheading" => %{<time datetime="#{article.datetime}">#{article.date_at}</time>},
          "content" => %{#{article.subheading} <a class="read-more" href="#{article.permalink}">Read More &raquo;</a>} 
        }
      end
    end
  end
end
