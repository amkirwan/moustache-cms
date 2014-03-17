class ThemeAsset 
  include Mongoid::Document

  attr_accessible :asset_path, :content_type

  # -- Fields ---
  field :asset_path 
  field :content_type

  after_initialize do |theme_asset|
    theme_asset.asset
    theme_asset.content_type = theme_asset.asset.content_type
  end

  def asset
    @asset ||= MoustacheCms::Application.assets.find_asset(self.asset_path)
  end

  def content_type
    asset.content_type
  end

  # -- Associations ----------
  belongs_to :theme_collection

  # -- Class Methods --------
  scope :css_files, ->{ where(content_type: "text/css") }
  scope :js_files, ->{ where(:content_type: /.*javascript$/i) }
  scope :javascripts, ->{ where(:content_type: /.*javascript$/i) }
  scope :images, ->{ where(content_type: /^image\/*/i) }
  scope :other_files, ->{ where({ content_type: {"$nin" => ['text/css', 'application/javascript', 'application/x-javascript', 'text/javascript', 'image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'image/vnd.microsoft.icon'] } }) } 

end
