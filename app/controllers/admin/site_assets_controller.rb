class Admin::SiteAssetsController < AdminBaseController
  include Etherweb::AssetCache                          
  
  load_and_authorize_resource :asset_collection
  load_and_authorize_resource :site_asset, :through => :asset_collection  
    
  # GET /admin/site_assets
  def index
  end

  # GET /admin/site_assets/1/edit
  def show
    render :edit
  end

  # GET /admin/site_assets/new
  def new
  end

  # GET /admin/site_assets/1/edit
  def edit
  end

  # POST /admin/site_assets
  def create
    created_updated_by_for @site_asset
    @site_asset.site = @current_site     
    try_site_asset_cache
    if @site_asset.save
      redirect_to admin_asset_collection_site_assets_path, :notice => "Successfully created the asset #{@site_asset.name}"
    else
      render :new
    end
  end

  # PUT /admin/site_assets/1
  def update
    @site_asset.updated_by = current_user
    try_site_asset_cache
    if @site_asset.update_attributes(params[:site_asset])
      redirect_to admin_asset_collection_site_assets_path, :notice => "Successfully updated the asset #{@site_asset.name}"
    else
      render :edit
    end
  end

  # DELETE /admin/site_assets/1
  def destroy
    if @site_asset.destroy
      redirect_to admin_asset_collection_site_assets_path, :notice => "Successfully deleted the asset #{@site_asset.name}"
    end
  end
  
  private
    def try_site_asset_cache                                                                  
      logger.debug "*"*10 + "#{params[:site_asset][:asset]}"
      if !params[:site_asset][:asset_cache].empty? && params[:site_asset][:asset].nil?
        set_from_cache(:cache_name => params[:site_asset][:asset_cache], :asset => @site_asset) 
      end
    end 
end
