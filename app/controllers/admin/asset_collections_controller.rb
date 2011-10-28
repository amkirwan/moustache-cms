class Admin::AssetCollectionsController < AdminBaseController   

  load_and_authorize_resource 

  respond_to :html, :xml, :json
  
  # GET /admin/asset_collections
  def index
    respond_with @asset_collections
  end
  
  # GET /admin/asset_collections/1
  def show
    respond_with @asset_collection
  end
  
  # GET /admin/asset_collections/new
  def new
    respond_with @asset_collection
  end
  
  #GET /admin/asset_collections/1/edit
  def edit
    respond_with @asset_collection
  end
  
  #POST /admin/asset_collections
  def create
    created_updated_by_for @asset_collection
    @asset_collection.site = @current_site
    respond_with(@asset_collection, :location => [:admin, :asset_collections]) do |format|
      if @asset_collection.save  
        flash[:notice] = "Successfully created the asset collection #{@asset_collection.name}"
      else
        format.any { render :new }
      end
    end
  end
  
  #PUT /admin/asset_collections/1
  def update
    @asset_collection.updated_by = @current_user
    respond_with(@asset_collection, :location => [:admin, @asset_collection]) do |format|
      if @asset_collection.update_attributes(params[:asset_collection])
        flash[:notice] = "Successfully updated the asset collection #{@asset_collection.name}"
      else
        format.any { render :edit }
      end 
    end
  end
  
  #DELETE /admin/asset_collections/1
  def destroy
    if @asset_collection.destroy
      flash[:notice] = "Successfully deleted the asset collection #{@asset_collection.name}"
    end
    respond_with @asset_collection, :location => [:admin, :asset_collections]
  end
end
