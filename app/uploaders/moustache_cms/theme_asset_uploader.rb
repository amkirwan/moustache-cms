class MoustacheCms::ThemeAssetUploader < MoustacheCms::BaseAssetUploader

  # Set the storage directory
  def store_dir
    "theme_assets/#{model._parent.site_id}/#{model._parent.name}/#{asset_type}"
  end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png css js swf flv eot svg ttf woff otf ico pdf mp4 m4v ogv webm flv)
   end

  def asset_type
    case 
    when image?
      "images"
    when stylesheet?
      "stylesheets"
    when javascript?
      "javascripts"
    else
      "assets"
    end
  end

end
