class Admin::ArticleCollectionsController < AdminBaseController

  load_and_authorize_resource 

  respond_to :html, :xml, :json

  # GET /admin/article_collections
  def index
    respond_with(:admin, @article_collections)
  end

  # GET /admin/article_collections/new
  def new
    respond_with(:admin, @article_collection)
  end

  # GET /admin/article_collections/1
  def show
    respond_with(:admin, @article_collection)
  end

  # GET /admin/article_collections/1/edit
  def edit
    respond_with(:admin, @article_collection)
  end

  # POST /admin/article_collections
  def create
    created_updated_by_for @article_collection
    @article_collection.site = @current_site
    if @article_collection.save
      flash[:notice] = "Successfully created the article collection #{@article_collection.name}"
    end
    respond_with(:admin, @article_collection, :location => [:admin, :article_collections])
  end
end

