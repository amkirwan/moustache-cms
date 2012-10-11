class ThemeCollection < BaseCollection

  # -- Callbacks ---
  before_destroy :remove_folder 
  
  created_updated(:theme_collections)
  collectable(:theme_assets)
  
  def remove_folder
    destroy_collection_folder
  end

end

