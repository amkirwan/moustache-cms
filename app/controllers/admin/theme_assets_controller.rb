class Admin::ThemeAssetsController < AdminBaseController
  
  def index
    @css_files = ThemeAsset.css_files(@current_site)
    @js_files = ThemeAsset.js_files(@current_site)
    @images = ThemeAsset.images(@current_site)
  end
  
  def new
  end
  
  def create
  end
  
end