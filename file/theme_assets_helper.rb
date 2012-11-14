module Admin::ThemeAssetsHelper

  def add_assets?
    if @css_files.empty? && @js_files.empty? && @images.empty?
      render :partial => 'add_asset'
    else
      output = ""
      output += render :partial => 'css_files' unless @css_files.empty?
      output += render :partial => 'js_files' unless @js_files.empty?
      output += render :partial => 'images' unless @images.empty?
      output += render :partial => 'other_files' unless @other_files.empty?
      output.html_safe
    end
  end

  def theme_asset_is_image?
    !@theme_asset.new_record? && @theme_asset.image?
  end

  def theme_asset_is_js_or_css
    !@theme_asset.new_record? && (@theme_asset.stylesheet? || @theme_asset.javascript?)
  end

  def theme_asset_is_js
    !@theme_asset.new_record? && @theme_asset.javascript?
  end
  
  def theme_asset_is_css
    !@theme_asset.new_record? && @theme_asset.stylesheet?
  end

  def add_tag_attrs(message, f_builder)
    if @theme_asset.new_record?
      content_tag :li do 
        content_tag :p do
          content_tag :i, message
        end
      end
    else
      render :partial => 'tags', :locals => {:f => f_builder}
    end
  end

  def edit_asset_field
    if theme_asset_is_js
      render :partial => 'edit_asset_fields', :locals => { :class_type => 'js_asset' }
    elsif theme_asset_is_css 
      render :partial => 'edit_asset_fields', :locals => { :class_type => 'css_asset' }
    end
  end

end
