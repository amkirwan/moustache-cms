class Admin::ArticlesController < AdminBaseController

  load_and_authorize_resource :article_collection
  load_and_authorize_resource :article, :through => :article_collection, :except => :new_meta_tag

  respond_to :html, :xml, :json
  respond_to :js, :only => [:index, :preview, :new_meta_tag, :new_author, :new_custom_field]

  # GET /admin/article_collections/1/articles
  def index
    @articles = @article_collection.articles.desc(:created_at).page(params[:page])
    respond_with(:admin, @article_collection, @articles)
  end

  # GET /admin/article_collections/1/articles/new
  def new
    @article.build_current_state
    @article.commentable = @article_collection.commentable
    respond_with(:admin, @article_collection, @articles)
  end

  # GET /admin/article_collections/1/articles/1/edit
  def edit
  end

  # POST /admin/article_collections/1/articles
  def create
    assign_protected_attributes @article
    respond_with(:admin, @article_collection, @article) do |format|
      if @article.save
        format.html { redirector [:edit, :admin, @article_collection, @article], [:admin, @article_collection, :articles], "Successfully created the article #{@article.title} in the collection #{@article_collection.name}" }
      end
    end
  end

  # PUT /admin/article_collections/1/articles/1
  def update
    assign_updated_by @article
    respond_with(:admin, @article_collection, @article) do |format| 
      if @article.update_attributes(params[:article])
        format.html { redirector [:edit, :admin, @article_collection, @article], [:admin, @article_collection, :articles], "Successfully updated the article #{@article.title} in the collection #{@article_collection.name}" }
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

  def preview
    @article = Article.find(params[:article_id])
    @article = @article.dup
    @article.assign_attributes(params[:article])
    @article.save_preview
  end

  def new_author
    @current_site = current_site
    @article = Article.find(params[:id])
  end

  def new_custom_field
    @base_class = Page.new
    @custom_field = CustomField.new
    render 'admin/custom_fields/new'
  end

end
