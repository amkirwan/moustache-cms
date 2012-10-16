class Admin::ArticleCollectionsController < AdminBaseController

  load_and_authorize_resource 

  respond_to :html, :xml, :json

  # GET /admin/article_collections
  def index
    @article_collections = @article_collections.where(:site_id => @current_admin_user.site_id).order_by(:name => 'ASC')
    respond_with(:admin, @article_collections)
  end

  # GET /admin/article_collections/new
  def new
    respond_with(:admin, @article_collection)
  end

  # GET /admin/article_collections/1
  def show
    redirect_to [:admin, @article_collection, :articles]
  end

  # GET /admin/article_collections/1/edit
  def edit
    respond_with(:admin, @article_collection)
  end
  
  # POST /admin/article_collections
  def create
    save_and_assign_notice(@article_collection, "Successfully created the article collection #{@article_collection.name}")
    respond_with(:admin, @article_collection, :location => [:admin, :article_collections])
  end

  # PUT /admin/article_collections/1
  def update
    update_and_assign_notice(@article_collection, params[:article_collection], "Successfully updated the article collection", :name)
    respond_with(:admin, @article_collection, :location => [:admin, :article_collections])
  end

  # DELETE /admin/article_collections/1
  def destroy
    if @article_collection.destroy
      flash[:notice] = "Successfully deleted the article collection #{@article_collection.name}"
    end
    respond_with(:admin, @article_collection)
  end
end

