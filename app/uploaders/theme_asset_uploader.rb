# encoding: utf-8

class ThemeAssetUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "sites/#{model.site_id}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end              

  version :thumb do                     
    process :resize_to_fill => [80, 80] 
  end
                             

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png css js swf flv eot svg ttf woff otf ico)
   end
    
  # Override the filename of the uploaded files:
   def filename
     "#{model.name}.#{file.extension}" if original_filename
   end    

   def image?(f)
     f.content_type.include? 'image'
   end

end
