class Admin::ArticleCollectionsController < AdminBaseController

  load_and_authorize_resource 

  respond_to :html, :xml, :json

  def index
    respond_with(:admin, @article_collections)
  end

  def new
  end

  def create
    created_updated_by_for @article_collection
    @article_collection.site = @current_site
    if @article_collection.save
      flash[:notice] = "Successfully created the article collection #{@article_collection.name}"
    end
    respond_with(:admin, @article_collection, :location => [:admin, :article_collections])
  end
end

