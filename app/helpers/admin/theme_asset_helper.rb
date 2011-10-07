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

  def manage_meta_tag page, meta_tag 
    case meta_tag.name
    when "title", "keywords", "description"
    else
      render :partial => "admin/pages/editable_tag_attr", :locals => { :theme_asset => theme_asset, :tag_attr => tag_attr}
    end
  end

  def add_tag_attr(message)
    if @theme_asset.new_record?
      content_tag :p do
        content_tag :i, message
      end
    else
      link_to "Add Tag Attribute", [:new, :admin, @theme_asset, :tag_attr], :remote => :true
    end
  end

end
