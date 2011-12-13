class Admin::ArticlesController < AdminBaseController

  load_and_authorize_resource :article_collection
  load_and_authorize_resource :article, :through => :article_collection

  respond_to :html, :xml, :json

  # GET /admin/article_collections/1/articles
  def index
    @articles = @article_collection.articles.desc(:created_at).page(params[:page])
    respond_with(:admin, @article_collection, @articles)
  end

  # GET /admin/article_collections/1/articles/new
  def new
    respond_with(:admin, @article_collection, @articles)
  end

  # POST /admin/article_collections/1/articles
  def create
    created_updated_by_for @article
    @article.site = @current_site
    respond_with(:admin, @article_collection, @article) do |format|
      if @article.save
        flash[:notice] = "Successfully created the article #{@article.title} in the collection @{@article_collection.name}"
        format.html { redirect_to [:admin, @article_collection, :articles], :notice => "Successfully created the article #{@article.title} in the collection #{@article_collection.name}" }
      end
    end
  end



end
