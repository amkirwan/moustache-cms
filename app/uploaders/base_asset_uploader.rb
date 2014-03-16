require 'carrierwave/processing/mime_types'

class BaseAssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "moustache_assets/#{model.site_id}"
  end    

  before :store, :remember_cache_id
  after :store, :delete_tmp_dir

  process :set_content_type

  # Override the filename of the uploaded files:
  def filename
    model.name.to_s
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
    content_type = model.content_type
    content_type.empty? ? false : content_type.include?('image')
  end

  def stylesheet?
    content_type = model.content_type
    content_type.empty? ? false : content_type.include?('css')
  end

  def javascript?
    content_type = model.content_type
    content_type.empty? ? false : content_type.include?('javascript')
  end

end
