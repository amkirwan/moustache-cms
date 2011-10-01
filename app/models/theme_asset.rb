class ThemeAsset 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_accessible :name, :description, :content_type, :width, :height, :file_size, :asset, :theme_asset_attributes
  
  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer 
  mount_uploader :asset, ThemeAssetUploader
   
  # -- Associations ----------
  embeds_one :element_attr
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"

  # -- Validations --------------
  validates :name, :presence => true 
  validates :site_id,
            :presence => true            
  validates :asset, :presence => true
  
  # -- Callbacks
  before_save :update_asset_attributes
  before_update :recreate, :if => "self.name_changed?"
    
  def recreate
    self.asset.recreate_versions!
    #self.asset.filename 
  end
  
  def update_asset_attributes         
    self.content_type = asset.file.content_type unless asset.file.content_type.nil?
    self.file_size = asset.file.size 
  end
  
  # -- Class Methods --------
  scope :css_files, lambda { |site| { :where => { :content_type => "text/css", :site_id => site.id }} }
  scope :js_files, lambda { |site| { :where => { :content_type => "text/javascript", :site_id => site.id }} }
  scope :images, lambda { |site| { :where => { :content_type => /^image/i, :site_id => site.id }} }
  scope :find_by_name, lambda { |name| { :where => { :name => name }} }

  def self.find_by_content_type_and_site_id(opts={})
    [:content_type, :site].inject(scoped) do |combined_scope, attr| 
      combined_scope.where(attr => opts[attr])
    end
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



