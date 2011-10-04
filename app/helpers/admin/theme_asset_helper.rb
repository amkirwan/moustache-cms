module Admin::ThemeAssetHelper

  def add_assets?
    @css_files.empty? && @js_files.empty? && @images.empty?
  end

  def theme_asset_is_image?
    !@theme_asset.new_record? && @theme_asset.image?
  end

  def theme_asset_is_js_or_css
    !@theme_asset.new_record? && (@theme_asset.stylesheet? || @theme_asset.javascript?)
  end
end
