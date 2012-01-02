module Admin::ThemeAssetsHelper

  def add_assets?
    if @css_files.empty? && @js_files.empty? && @images.empty?
      render :partial => 'add_asset'
    else
      concat(render :partial => 'css_files') unless @css_files.empty?
      concat(render :partial => 'js_files') unless @js_files.empty?
      concat(render :partial => 'images') unless @images.empty?
      render :partial => 'other_files' unless @other_files.empty?
    end
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

  def edit_asset_field(version=nil)
      if theme_asset_is_js_or_css
        content_tag :li do
          text_area_tag :theme_asset_file_content, @theme_asset.asset.read, :class => "code", :cols => "80", :rows => "30"
        end
      elsif version == :without_md5
        content_tag :li, :class => 'img_thumb' do
          link_to image_tag(@theme_asset.asset.url, :class => "theme_asset_thumb"), "http://#{request.host}#{@theme_asset.asset.without_fingerprint.url}" 
        end
      else
        content_tag :li, :class => 'img_thumb' do
          link_to image_tag(@theme_asset.asset.url, :class => "theme_asset_thumb"), "http://#{request.host}#{@theme_asset.asset.url}" 
        end
      end
  end

end
