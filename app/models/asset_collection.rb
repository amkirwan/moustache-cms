class AssetCollection < MoustacheCollection::Metal

  # -- Callbacks
  before_destroy :remove_folder 
  
  created_updated(:asset_collections)
  collectable(:site_assets)
  
  def remove_folder
    destroy_collection_folder('site_assets')
  end

end
