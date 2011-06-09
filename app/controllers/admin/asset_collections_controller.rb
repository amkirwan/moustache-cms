class Admin::AssetCollectionsController < AdminBaseController   
  
  # GET /admin/asset_collections
  def index
  end
  
  # GET /admin/asset_collections/1
  def show
  end
  
  # GET /admin/asset_collections/new
  def new
  end
  
  #GET /admin/asset_collections/1/edit
  def edit
  end
  
  #POST /admin/asset_collections
  def create
    created_updated_by_for @asset_collection
    @asset_collection.site = @current_site
    if @asset_collection.save  
      redirect_to admin_asset_collections_path, :notice => "Successfully created the asset collection #{@asset_collection.name}"
    else
      render :new
    end
  end
  
  #PUT /admin/asset_collections/1
  def update
    @asset_collection.updated_by = @current_user
    if @asset_collection.update_attributes(params[:asset_collection])
      redirect_to [:admin, @asset_collection], :notice => "Successfully updated the asset collection #{@asset_collection.name}"
    else
      render :edit
    end
  end
  
  #DELETE /admin/asset_collections/1
  def destroy
    if @asset_collection.destroy
      redirect_to admin_asset_collections_path, :notice => "Successfully deleted the asset collection #{@asset_collection.name}"
    end
  end
end
