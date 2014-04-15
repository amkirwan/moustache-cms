class ThemeAsset 
  include Mongoid::Document

  attr_accessible :filename, :asset_path, :content_type, :asset_collection_name

  # -- Fields ---
  field :filename
  field :asset_path 
  field :content_type
  field :asset_collection_name

  after_initialize do |theme_asset|
    theme_asset.asset 
    theme_asset.content_type = theme_asset.asset.content_type
    theme_asset.filename = File.basename(theme_asset.asset.pathname)
  end

  def asset
    @asset ||= MoustacheCms::Application.assets.find_asset(self.asset_path)
  end

  def filename
    @filename ||= File.basename(asset.pathname)
  end

  def asset_filename
    self.asset_collection_name + '/' + filename
  end

  def asset_path
    MoustacheCms::Application.config.assets.prefix + '/' + self.asset_collection_name + '/' + filename
  end

  def asset_digest_path
    '/' + self.asset.digest_path
  end

  def content_type
    @content_type ||= asset.content_type
  end

  def url_md5
    MoustacheCms::Application.config.assets.prefix + '/' + asset.digest_path
  end

  # -- Associations ----------
  belongs_to :theme_collection

  # -- Class Methods --------
  scope :css_files, ->{ where(content_type: "text/css") }
  scope :js_files, ->{ where(content_type: /.*javascript$/i) }
  scope :javascripts, ->{ where(content_type: /.*javascript$/i) }
  scope :images, ->{ where(content_type: /^image\/*/i) }
  scope :other_files, ->{ where({ content_type: {"$nin" => ['text/css', 'application/javascript', 'application/x-javascript', 'text/javascript', 'image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'image/vnd.microsoft.icon'] } }) } 

end
