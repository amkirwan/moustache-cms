class ThemeAssetUploader < BaseAssetUploader

  # Set the storage directory
  def store_dir
    "theme_assets/#{model._parent.site_id}/#{model._parent.name}/#{asset_type(model.asset_identifier)}" 
  end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png css js swf flv eot svg ttf woff otf ico pdf mp4 m4v ogv webm flv)
   end
    
   def image?(sanitized_file)    
     types = mime_types(sanitized_file)
     if types.empty?
       false
      else
        types.first.content_type.include? 'image'
      end
   end
  
   def stylesheet?(sanitized_file)
     types = mime_types(sanitized_file)
     if types.empty?
       false
      else
        types.first.content_type.include? 'css'
      end
   end
   
   def javascript?(sanitized_file)
     types = mime_types(sanitized_file)
     if types.empty?
       false
      else
        types.first.content_type.include? 'javascript'
      end
   end

    def asset_type(name)
      sanitized_file = CarrierWave::SanitizedFile.new(name)
      case 
      when stylesheet?(sanitized_file)
        "stylesheets"
      when image?(sanitized_file)
        "images"
      when javascript?(sanitized_file)
        "javascripts"
      when image?(sanitized_file)
        "images"
      else
        "assets"
      end
    end
end
