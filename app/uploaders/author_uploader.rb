class AuthorUploader < BaseAssetUploader

  # set the storage directory
  def store_dir
    "authors/#{model.site_id}"
  end    
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png)
   end
    
  # Override the filename of the uploaded files:
  def filename
    "#{model.firstname.parameterize}-#{model.lastname.parameterize}.#{model.image.file.extension}"
  end

end

