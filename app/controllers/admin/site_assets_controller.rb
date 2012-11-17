class Admin::SiteAssetsController < AdminBaseController
  include MoustacheCms::AssetCache                    
        
  load_and_authorize_resource :asset_collection
  load_and_authorize_resource :site_asset, :through => :asset_collection  

  respond_to :html, :xml, :json
  respond_to :js, :only => :new
    
  # GET /admin/site_assets
  def index
    respond_with(:admin, @asset_collection, @site_assets) do |format|
      format.html { render 'admin/asset_collections/show' }
    end
  end

  def show
    respond_with(:admin, @asset_collection, @site_asset) do |format|
     format.html { render :edit }
    end
  end

  # GET /admin/asset_collections/asset_collection_id/site_assets/new
  def new
    respond_with(:admin, @asset_collection, @site_asset)
  end

  # GET /admin/asset_collections/id/site_assets/1/edit
  def edit
    respond_with(:admin, @asset_collection, @site_asset)
  end

  # POST /admin/asset_collections/id/site_assets
  def create
    process_create_params
    creator_updator_set_id @site_asset    
    @site_asset.asset = params[:file]
    asset_create_respond_with(@asset_collection, @site_asset, :site_assets) do
      "Successfully created the site asset #{@site_asset.name}"
    end
  end

  # PUT /admin/asset_collections/id/site_assets/1
  def update
    @site_asset.updator_id = current_admin_user.id
    change_name_md5(@site_asset, params[:site_asset][:name])
    respond_with(:admin, @asset_collection, @site_asset) do |format|
      if @site_asset.update_attributes(params[:site_asset])
        format.html { redirect_to [:admin, @asset_collection, :site_assets], :notice => "Successfully updated the asset #{@site_asset.name}" }
      end
    end
  end

  # DELETE /admin/asset_collections/id/site_assets/1
  def destroy
    @site_asset.destroy
    flash[:notice] = "Successfully deleted the asset #{@site_asset.name}"
    respond_with(:admin, @asset_collection, @site_asset)
  end

  private
   
    def process_name(original_filename)
      @site_asset.name = original_filename
    end

    def process_create_params
      if params[:site_asset].nil?
        process_name(params[:name])
      else
        try_site_asset_cache
        process_name(params[:site_asset][:name])
      end
    end

end
