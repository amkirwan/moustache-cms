module Admin::ArticlesHelper

    def list_articles
    if @article_collection.articles.empty?
      content_tag :div, :class => 'add_some' do
        content_tag :h4 do
          link_to 'Add Articles', [:new, :admin, @article_collection, :article]
        end
      end
    else
      render :partial => 'admin/article_collections/article', :collection => @article_collection.articles.asc(:created_at)
    end
  end

  def published?(article)
    article.current_state.published? ? 'published' : 'draft'
  end
end
