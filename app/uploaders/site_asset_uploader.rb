# encoding: utf-8
require 'mime/types'

class SiteAssetUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "sites/#{model.site_id}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
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

   def image?(sanitized_file)    
     types = mime_types(sanitized_file)
     if types.empty?
       false
      else
        types.first.content_type.include? 'image'
      end
   end
   
   
   private
   
    def mime_types(file)
      MIME::Types.of(file.extension)
    end
end
