class Admin::ThemeCollectionsController < AdminBaseController   

  load_and_authorize_resource 

  respond_to :html, :xml, :json
  
  # GET /admin/asset_collections
  def index
    respond_with(:admin, @theme_collections)
  end
  
  # GET /admin/asset_collections/1
  def show
    @css_files = @theme_collection.theme_assets.css_files
    @js_files = @theme_collection.theme_assets.js_files
    @images = @theme_collection.theme_assets.images
    @other_files = ThemeAsset.other_files(@current_site)
    respond_with(:admin, @theme_collection)
  end
  
  # GET /admin/asset_collections/new
  def new
    respond_with(:admin, @theme_collection)
  end
  
  #GET /admin/asset_collections/1/edit
  def edit
    respond_with @theme_collection
  end
  
  #POST /admin/asset_collections
  def create
    created_updated_by_for @theme_collection
    @theme_collection.site = current_site
    if @theme_collection.save
      flash[:notice] = "Successfully created the asset collection #{@theme_collection.name}"
    end
    respond_with([:admin, @theme_collection])
    #respond_with(@theme_collection, :location => [:admin, @theme_collection, :theme_assets])
  end
  
  #PUT /admin/asset_collections/1
  def update
    @theme_collection.updated_by = @current_admin_user
    if @theme_collection.update_attributes(params[:asset_collection])
      flash[:notice] = "Successfully updated the asset collection #{@theme_collection.name}"
    end
    respond_with([:admin, @theme_collection])
    #respond_with(@theme_collection, :location => [:admin, @theme_collection, :theme_assets])
  end
  
  #DELETE /admin/asset_collections/1
  def destroy
    @theme_collection.destroy
    flash[:notice] = "Successfully deleted the asset collection #{@theme_collection.name}"
    respond_with(:admin, @theme_collection)
  end
end

