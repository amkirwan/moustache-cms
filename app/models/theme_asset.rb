class ThemeAsset 
  include Mongoid::Document

  attr_accessible :filename, :content_type, :pathname, :logical_path, :digest_path

  # -- Fields ---
  field :filename
  field :content_type
  field :pathname
  field :logical_path
  field :digest_path
  

  after_initialize do |theme_asset|
    theme_asset.asset
    %w{content_type pathname logical_path digest_path}.each do |method|
      val = theme_asset.asset.send(method.to_sym)
      theme_asset.send("#{method}=".to_sym, val.to_s)
    end
  end

  def asset
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
