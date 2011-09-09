class Admin::SiteAssetsController < AdminBaseController
  include HandlebarCms::AssetCache                    
        
  prepend_before_filter :find_site_asset, :only => [:edit, :update, :destroy]
  
  load_and_authorize_resource :asset_collection
  load_and_authorize_resource :site_asset, :through => :asset_collection  
    
  # GET /admin/site_assets
  def index
    redirect_to [:admin, @asset_collection]
  end

  def show
    render :edit
  end

  # GET /admin/asset_collections/id/site_assets/new
  def new
  end

  # GET /admin/asset_collections/id/site_assets/1/edit
  def edit
  end

  # POST /admin/site_assets
  def create
    creator_updator_set_id @site_asset    
    try_site_asset_cache
    if @asset_collection.site_assets << @site_asset && @site_asset.valid?
      redirect_to [:admin, @asset_collection], :notice => "Successfully created the asset #{@site_asset.name}"
    else
      render :new
    end
  end

  # PUT /admin/site_assets/1
  def update
    @site_asset.updator_id = @current_user.id
    if @site_asset.update_attributes(params[:site_asset])
      redirect_to [:admin, @asset_collection], :notice => "Successfully updated the asset #{@site_asset.name}"
    else
      render :edit
    end
  end

  # DELETE /admin/site_assets/1
  def destroy
    if @site_asset.destroy
      redirect_to [:admin, @asset_collection], :notice => "Successfully deleted the asset #{@site_asset.name}"
    end
  end
  
  private
    def try_site_asset_cache                                                                  
      if !params[:site_asset][:asset_cache].empty? && params[:site_asset][:asset].nil?
        set_from_cache(:cache_name => params[:site_asset][:asset_cache], :asset => @site_asset) 
      end
    end 
    
    def creator_updator_set_id(site_asset)
      site_asset.creator_id = @current_user.id
      site_asset.updator_id = @current_user.id
    end
    
    def find_site_asset
      @asset_collection = AssetCollection.where(:site_id => current_site.id).find(params["asset_collection_id"])
      @site_asset = @asset_collection.site_assets.find(params["id"])
    end
end
