# encoding: utf-8

class SiteAssetUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::MiniMagick
  #include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  #storage :file
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end             
  
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end 

  version :thumb, :if => :image? do                     
    process :resize_to_fill => [50, 50] 
  end
                             

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png pdf swf flv svg)
   end
    
  # Override the filename of the uploaded files:
   def filename
     "#{model.name}.#{file.extension}" if original_filename
   end    
   
   def image?
     model.content_type.include? 'image'
   end 
end
