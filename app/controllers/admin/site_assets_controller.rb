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
    respond_with(:admin, @asset_collection, @site_asset) do |format|
      if @site_asset.save
        format.html { redirect_to [:admin, @asset_collection, :site_assets], :notice => "Successfully created the asset #{@site_asset.name}" }
      end
    end
  end

  # PUT /admin/asset_collections/id/site_assets/1
  def update
    @site_asset.updator_id = current_admin_user.id
    change_name_md5
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
    def try_site_asset_cache                                                                  
      if !params[:site_asset][:asset_cache].empty? && params[:site_asset][:asset].nil?
        set_from_cache(:cache_name => params[:site_asset][:asset_cache], :asset => @site_asset) 
      end
    end 
    
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

    def change_name_md5
      @site_asset.name = params[:site_asset][:name]
      if @site_asset.name_changed?
        old_name_split = @site_asset.filename_md5_was.split('-')
        hash_ext = old_name_split.pop
        hash = hash_ext.split('.').shift
        @site_asset.filename_md5 = "#{@site_asset.name}-#{hash}.#{@site_asset.asset.file.extension}"
        generate_paths
      end
    end

    def generate_paths
      @site_asset.file_path_md5 = File.join(Rails.root, 'public', @site_asset.asset.store_dir, '/', @site_asset.filename_md5)
      @site_asset.url_md5 = "/#{@site_asset.asset.store_dir}/#{@site_asset.filename_md5}"
      @site_asset.file_path_md5_old = @site_asset.file_path_md5_was if @site_asset.file_path_md5_changed?
    end
end
