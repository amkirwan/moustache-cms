# encoding: utf-8
require 'mime/types'

class ThemeAssetUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "sites/#{model.site_id}/#{model.class.to_s.underscore}/#{asset_type(model.asset_filename)}"
  end              

  version :thumb, :if => :image? do                     
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
          
   private
   
    def mime_types(file)
      MIME::Types.of(file.extension)
    end
    
    def asset_type(filename)
      sanitized_file = CarrierWave::SanitizedFile.new(filename)
      case 
      when stylesheet?(sanitized_file)
        "stylesheets"
      when image?(sanitized_file)
        "images"
      when javascript?(sanitized_file)
        "javascripts"
      else
        "assets"
      end
    end
end
