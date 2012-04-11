# encoding: utf-8
require 'carrierwave/processing/mime_types'

class AuthorUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    "authors/#{model.site_id}"
  end    
  
  before :store, :remember_cache_id
  after :store, :delete_tmp_dir

  process :set_content_type

  # store! nil's the cache_id after it finishes so we need to remember it for deletition
  def remember_cache_id(new_file)
    @cache_id_was = cache_id
  end
  
  def delete_tmp_dir(new_file)
    # make sure we don't delete other things accidentally by checking the name pattern
    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      if Rails.env == "test"                                            
        FileUtils.rm_rf(File.join(Rails.root, "spec", "tmp", cache_dir, @cache_id_was))  
      else
        FileUtils.rm_rf(File.join(Rails.root, cache_dir, @cache_id_was))
      end
    end
  end          

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png)
   end
    
  # Override the filename of the uploaded files:
  def filename
    @name ||= "#{model.firstname.parameterize}-#{model.lastname.parameterize}.#{model.image.file.extension}"
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

