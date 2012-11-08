require 'carrierwave/processing/mime_types'

class MoustacheCms::BaseAssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  storage :file

  def store_dir
    "moustache_assets/#{model.site_id}"
  end    

  before :store, :remember_cache_id
  after :store, :delete_tmp_dir

  process :set_content_type

  def mime_types
    MIME::Types.of(model.asset_identifier)
  end

  # Override the filename of the uploaded files:
  def filename
    "#{model.name}.#{file.extension}"
  end
  
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
    
  def image?
    types = mime_types
    if types.empty?
      false
    else
      types.first.content_type.include? 'image'
    end
  end

  def stylesheet?
    types = mime_types
    if types.empty?
     false
    else
      types.first.content_type.include? 'css'
    end
  end

  def javascript?
    types = mime_types
    if types.empty?
      false
    else
      types.first.content_type.include? 'javascript'
    end
  end

end
