class Admin::ThemeAssetsController < AdminBaseController
  include Etherweb::AssetCache  
  
  # GET /admin/theme_assets 
  def index
    @css_files = ThemeAsset.css_files(@current_site)
    @js_files = ThemeAsset.js_files(@current_site)
    @images = ThemeAsset.images(@current_site)
  end  
  
  # GET /admin/theme_assets/1/edit
  def show
    render :edit
  end
  
   # GET /admin/theme_assets/new 
  def new
  end
   
  # POST /admin/theme_assets
  def create
    created_updated_by_for @theme_asset
    @theme_asset.site = @current_site       
    try_theme_asset_cache 
    if @theme_asset.save
      flash[:notice] = "Successfully created the theme asset #{@theme_asset.name}"
      redirect_to admin_theme_assets_path
    else
      render :new
    end
  end    
  
  # GET /admin/theme_asset/1/edit
  def edit
  end
   
  # PUT /admin/theme_assets/1 
  def update   
    @theme_asset.updated_by = current_user       
    try_theme_asset_cache                  
    if @theme_asset.update_attributes(params[:theme_asset]) && @theme_asset.update_file_content(params[:theme_asset_file_content])
      flash[:notice] = "Successfully updated the theme asset #{@theme_asset.name}"
      redirect_to admin_theme_assets_path
    else                                                        
      render :edit
    end  
  end                                                            
  
  def destroy
    if @theme_asset.destroy
      flash[:notice] = "Successfully deleted the theme asset #{@theme_asset.name}"
      redirect_to admin_theme_assets_path
    end
  end   
  
  private
    def try_theme_asset_cache 
      if params[:theme_asset][:asset_cache].empty? && params[:theme_asset][:asset].nil?
        set_from_cache(:cache_name => params[:theme_asset][:asset_cache], :asset => params[:theme_asset][:asset])
      end
    end
end