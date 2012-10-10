class SiteAsset < BaseAsset
  include Mongoid::Document::Taggable

  attr_accessible :tag_list
  
  # -- Fields ---
  mount_uploader :asset, SiteAssetUploader  

  set_asset_folder :site_assets

  # -- Associations ------
  embedded_in :asset_collection  
  
  # -- Instance Methods     
  def image?
    self.asset.image?(self.asset.file)
  end

end
