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

 def manage_meta_tag article, meta_tag 
    case meta_tag.name
    when "title", "keywords", "description"
    else
      link_to "Delete", [:admin, article, meta_tag], :confirm => "Are you sure you want to delete the meta tag #{meta_tag.name}", :method => :delete, :class => "delete", :remote => true
    end
  end


end
