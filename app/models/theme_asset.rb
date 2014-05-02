class ThemeAsset 
  include Mongoid::Document
  include MoustacheCms::Siteable

  attr_accessible :filename

  # -- fields ---
  field :filename
  field :asset

  # -- validations ---
  validates :filename, presence: true

  # -- initialize -- 
  after_initialize do |theme_asset|
    theme_asset.asset
  end
  
  # -- delegate methods to asset
  %w{content_type pathname logical_path digest_path}.each do |method|
    delegate method.to_sym, to: :asset
  end

  def asset
    return nil if self.filename.nil?
    @asset ||= MoustacheCms::Application.assets.find_asset(self.filename)
  end

  def asset_path
    MoustacheCms::Application.config.assets.prefix + '/' + self.logical_path
  end

  def asset_digest_path
    MoustacheCms::Application.config.assets.prefix + '/' + self.digest_path
  end

  alias_method :url_md5, :asset_digest_path

  # -- Associations ----------
  belongs_to :theme_collection

  # -- Class Methods --------
  scope :css_files, ->{ where(content_type: "text/css") }
  scope :js_files, ->{ where(content_type: /.*javascript$/i) }
  scope :javascripts, ->{ where(content_type: /.*javascript$/i) }
  scope :images, ->{ where(content_type: /^image\/*/i) }
  scope :other_files, ->{ where({ content_type: {"$nin" => ['text/css', 'application/javascript', 'application/x-javascript', 'text/javascript', 'image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'image/vnd.microsoft.icon'] } }) } 

end
