class Admin::ThemeCollectionsController < AdminBaseController   

  load_and_authorize_resource 

  respond_to :html, :xml, :json
  
  # GET /admin/asset_collections
  def index
    respond_with(:admin, @theme_collections)
  end
  
  # GET /admin/asset_collections/1
  def show
    @css_files = @theme_collection.theme_assets.css_files.asc(:name)
    @js_files = @theme_collection.theme_assets.js_files.asc(:name)
    @images = @theme_collection.theme_assets.images.asc(:name)
    @other_files = @theme_collection.theme_assets.other_files.asc(:name)
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
    respond_with(:admin, @theme_collection) do |format|
      if @theme_collection.save
        format.html { redirect_to redirector_path(@theme_collection), :notice => "Successfully created the theme collection #{@theme_collection.name}" }
      end
    end
  end
  
  #PUT /admin/asset_collections/1
  def update
    @theme_collection.updated_by = @current_admin_user
    respond_with(:admin, @theme_collection) do |format| 
      if @theme_collection.update_attributes(params[:theme_collection]) 
        format.html { redirect_to redirector_path(@theme_collection), :notice => "Successfully updated the theme collection #{@theme_collection.name}" }
      end
    end
  end
  
  #DELETE /admin/asset_collections/1
  def destroy
    @theme_collection.destroy
    flash[:notice] = "Successfully deleted the asset collection #{@theme_collection.name}"
    respond_with(:admin, @theme_collection)
  end
end

