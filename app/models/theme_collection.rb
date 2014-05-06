class ThemeCollection 
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::Siteable
  include MoustacheCms::CreatedUpdatedBy
  # -- Callbacks ---
  
  created_updated(:theme_collections)
  
  attr_accessible :name

  # -- Fields ---
  field :name

  # -- Associations ---
  has_many :theme_assets

  # -- Validation ---
  validates :name,
            :presence => true

  # -- Initialize assets ---
  
  def load_assets
    if self.persisted?
      self.theme_assets.delete_all
      if MoustacheCms::Application.config.respond_to?(:theme_asset_path)
        files = Dir.glob(MoustacheCms::Application.config.theme_asset_path[self.name.to_sym])
      else
        files = Dir.glob("#{Rails.root}/vendor/assets/*/#{self.name}/*")
      end
      files.each do |file|
        unless File.basename(file) =~ /^_.*/ || File.directory?(file) # don't load partials or sub directories
          filename = self.name + '/' + File.basename(file)
          self.theme_assets << ThemeAsset.new(filename: filename, site: self.site, theme_collection: self)
        end
      end
      self.save
    end
  end
  
end
