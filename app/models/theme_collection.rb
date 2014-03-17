class ThemeCollection 
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::Siteable
  include MoustacheCms::CreatedUpdatedBy
  # -- Callbacks ---
  # before_destroy :remove_folder 
  
  created_updated(:theme_collections)
  
  attr_accessible :name

  # -- Fields ---
  field :name

  # -- Associations ----------
  has_many :theme_assets

  # -- Initialize assets ---
  after_initialize do |theme_collection|
    if theme_collection.persisted?
      theme_collection.theme_assets = nil
      files = Dir.glob("#{Rails.root}/vendor/assets/*/#{theme_collection.name}/**")
      files.each do |file|
        theme_collection.theme_assets << ThemeAsset.new(asset_path: file)
      end
    end
  end
  
end
