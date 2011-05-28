class Admin::ThemeAssetsController < AdminBaseController
  include Etherweb::AssetCache
  def index
    @css_files = ThemeAsset.css_files(@current_site)
    @js_files = ThemeAsset.js_files(@current_site)
    @images = ThemeAsset.images(@current_site)
  end
  
  def new
  end
  
  def create
    created_updated_by_for @theme_asset
    @theme_asset.site = @current_site     
    set_from_cache(:asset => @theme_asset, :cache_name => params[:theme_asset][:source_cache], :source => params[:theme_asset][:source])
    if @theme_asset.save
      flash[:notice] = "Successfully created the theme asset #{@theme_asset.name}"
      redirect_to admin_theme_assets_path
    else
      render :new
    end
  end
  
  private 
    def set_from_cache(cache_name)
      if !params[:theme_asset][:source_cache].empty? && params[:theme_asset][:source].nil?
        @theme_asset.source.retrieve_from_cache!(cache_name)
        @theme_asset.source.store!
      end
    end
  
end