class ThemeAsset 
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :name, 
                  :description, 
                  :content_type,
                  :width,
                  :height,
                  :file_size,
                  :asset,
                  :theme_asset_attributes,
                  :tag_attrs_attributes
  
  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer 
  field :creator_id
  field :updator_id
  mount_uploader :asset, ThemeAssetUploader
   
  # -- Associations ----------
  embedded_in :article_collection  
  embeds_many :tag_attrs, :as => :tag_attrable

  accepts_nested_attributes_for :tag_attrs

  # -- Validations --------------
  validates :name, :presence => true 
  validates :asset, :presence => true
  
  # -- Callbacks
  before_save :update_asset_attributes
  before_update :recreate
    
  def recreate
    self.asset.recreate_versions!
  end
  
  def update_asset_attributes         
    self.content_type = asset.file.content_type unless asset.file.content_type.nil?
    self.file_size = asset.file.size 
  end
  
  # -- Class Methods --------
  scope :css_files, lambda { { :where => { :content_type => "text/css" }} }
  scope :js_files, lambda { { :where => { :content_type => "text/javascript" }} }
  scope :images, lambda { { :where => { :content_type => /^image/i }} }
  scope :find_by_name, lambda { |name| { :where => { :name => name }} }


  def self.find_by_content_type_and_site_id(opts={})
    [:content_type, :site].inject(scoped) do |combined_scope, attr| 
      combined_scope.where(attr => opts[attr])
    end
  end


  def self.other_files(site)
    ThemeCollection.criteria.for_ids(site.id).where("theme_assets.content_type" => {"$nin" => ['text/css', 'text/javascript', /^image/i]}).to_a
  end
  
  # -- Instance Methods ----------
  %w{image stylesheet javascript}.each do |type|
    define_method("#{type}?") do
      self.asset.send("#{type}?", self.asset.file)
    end
  end
  
  def update_file_content(file_contents)
    File.open(self.asset.path, "wb") { |f| f.write(file_contents) }
  end

end



