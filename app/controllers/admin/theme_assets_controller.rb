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
    set_from_cache(:asset => @theme_asset, :cache_name => params[:theme_asset][:asset_cache], :asset => params[:theme_asset][:asset])
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
    
  end
  
  private 
    def set_from_cache(cache_name)
      if !params[:theme_asset][:asset_cache].empty? && params[:theme_asset][:asset].nil?
        @theme_asset.asset.retrieve_from_cache!(cache_name)
        @theme_asset.asset.store!
      end
    end
  
end