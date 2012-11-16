class SiteAssetUploader < BaseAssetUploader

  # Set the storage directory
  def store_dir
    "site_assets/#{model._parent.site_id}/#{model._parent.name}"
  end    
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
   %w(jpg jpeg gif png pdf mp4 m4v ogv webm flv otf)
  end

  def filename
    "#{model.name}"  
  end
    
end
