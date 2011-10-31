class Admin::AssetCollectionsController < AdminBaseController   

  load_and_authorize_resource 

  respond_to :html, :xml, :json
  
  # GET /admin/asset_collections
  def index
    respond_with(:admin, @asset_collections)
  end
  
  # GET /admin/asset_collections/1
  def show
    respond_with(:admin, @asset_collection)
  end
  
  # GET /admin/asset_collections/new
  def new
    respond_with(:admin, @asset_collection)
  end
  
  #GET /admin/asset_collections/1/edit
  def edit
    respond_with @asset_collection
  end
  
  #POST /admin/asset_collections
  def create
    created_updated_by_for @asset_collection
    @asset_collection.site = @current_site
    if @asset_collection.save
      flash[:notice] = "Successfully created the asset collection #{@asset_collection.name}"
    end
    respond_with(:admin, @asset_collection)
  end
  
  #PUT /admin/asset_collections/1
  def update
    @asset_collection.updated_by = @current_user
    if @asset_collection.update_attributes(params[:asset_collection])
      flash[:notice] = "Successfully updated the asset collection #{@asset_collection.name}"
    end
    respond_with(:admin, @asset_collection) 
  end
  
  #DELETE /admin/asset_collections/1
  def destroy
    @asset_collection.destroy
    flash[:notice] = "Successfully deleted the asset collection #{@asset_collection.name}"
    respond_with(:admin, @asset_collection)
  end
end
