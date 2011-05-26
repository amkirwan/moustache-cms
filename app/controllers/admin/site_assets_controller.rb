class Admin::SiteAssetsController < AdminBaseController
  # GET /admin/media_files
  def index
  end

  # GET /admin/media_files/1
  def show
    render :edit
  end

  # GET /admin/media_files/new
  def new
  end

  # GET /admin/media_files/1/edit
  def edit
  end

  # POST /admin/media_files
  def create
    created_updated_by_for @site_asset
    @site_asset.site = @current_site 
    if !params[:site_asset][:source_cache].empty? && params[:site_asset][:source].nil?
      set_from_cache(params[:site_asset][:source_cache])
    end
    if @site_asset.save
      flash[:notice] = "Successfully created the asset #{@site_asset.name}"
      redirect_to admin_site_assets_path
    else
      render :new
    end
  end

  # PUT /admin/site_assets/1
  def update
    @site_asset.updated_by = current_user
    if !params[:site_asset][:source_cache].empty? && params[:site_asset][:source].nil?
      set_from_cache(params[:site_asset][:source_cache])
    end
    if @site_asset.update_attributes(params[:site_asset])
      flash[:notice] = "Successfully updated the asset #{@site_asset.name}"
      redirect_to admin_site_assets_path
    else
      render :edit
    end
  end

  # DELETE /admin/site_assets/1
  def destroy
    if @site_asset.destroy
      flash[:notice] = "Successfully deleted the asset #{@site_asset.name}"
      redirect_to admin_site_assets_path
    end
  end
  
  private 
    def set_from_cache(cache_name)
      @site_asset.source.retrieve_from_cache!(cache_name)
      @site_asset.source.store!
    end
end
