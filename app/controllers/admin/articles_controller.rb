class Admin::ArticlesController < AdminBaseController

  load_and_authorize_resource :article_collection
  load_and_authorize_resource :article, :through => :article_collection, :except => :new_meta_tag

  respond_to :html, :xml, :json
  respond_to :js, :only => :new_meta_tag

  # GET /admin/article_collections/1/articles
  def index
    @articles = @article_collection.articles.desc(:created_at).page(params[:page])
    respond_with(:admin, @article_collection, @articles)
  end

  # GET /admin/article_collections/1/articles/new
  def new
    @article.build_current_state
    respond_with(:admin, @article_collection, @articles)
  end

  # GET /admin/article_collections/1/articles/1/edit
  def edit
  end

  # POST /admin/article_collections/1/articles
  def create
    @article.site = @current_site
    created_updated_by_for @article
    respond_with(:admin, @article_collection, @article) do |format|
      if @article.save
        format.html { redirect_to [:admin, @article_collection, :articles], :notice => "Successfully created the article #{@article.title} in the collection #{@article_collection.name}" }
      end
    end
  end

  # PUT /admin/article_collections/1/articles/1
  def update
    @article.updated_by = @current_admin_user
    respond_with(:admin, @article_collection, @article) do |format| 
      if @article.update_attributes(params[:article])
        format.html { redirect_to [:admin, @article_collection, :articles], :notice =>  "Successfully updated the article #{@article.title} in the collection #{@article_collection.name}"}
      end
    end
  end

  # DELETE /admina/article_collection/1/articles/1
  def destroy
    if @article.destroy
      flash[:notice] = "Successfully deleted the article #{@article.title}"
    end
    respond_with(:admin, @article_collection, @article, :location => [:admin, @article_collection, :articles])
  end

  def new_meta_tag
    @base_class = Page.new
    @meta_tag = MetaTag.new
    render 'admin/meta_tags/new.js'
  end

end
