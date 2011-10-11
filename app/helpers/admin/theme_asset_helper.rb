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

  def add_tag_attrs(message, f_builder)
    if @theme_asset.new_record?
      content_tag :p do
        content_tag :i, message
      end
    else
      render :partial => 'tags', :locals => {:f => f_builder}
    end
  end


end
