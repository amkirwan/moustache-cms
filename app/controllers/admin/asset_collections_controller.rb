class Admin::AssetCollectionsController < AdminBaseController   

  load_and_authorize_resource 

  respond_to :html, :xml, :json
  
  # GET /admin/asset_collections
  def index
    @asset_collections = @asset_collections.where(:site_id => @current_admin_user.site_id)
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
    assign_protected_attributes @asset_collection
    if @asset_collection.save
      flash[:notice] = "Successfully created the asset collection #{@asset_collection.name}"
    end
    respond_with(:admin, @asset_collection)
  end
  
  #PUT /admin/asset_collections/1
  def update
    assign_updated_by @asset_collection
    move_directory(@asset_collection.name, params[:asset_collection][:name], @asset_collection.site_id, 'site_assets')
    if @asset_collection.update_attributes(params[:asset_collection])
      flash[:notice] = "Successfully updated the asset collection #{@asset_collection.name}"
    end
    respond_with(:admin, @asset_collection) 
  end
  
  #DELETE /admin/asset_collections/1
  def destroy
    @asset_collection.destroy
    flash[:notice] = "Successfully deleted the asset collection #{@asset_collection.name}"
    respond_with(:admin, @asset_collection, :location => [:admin, :asset_collections])
  end
end
