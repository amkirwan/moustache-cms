class SiteAsset
  include Mongoid::Document
  
  attr_accessible :name, :description, :content_type, :width, :height, :file_size, :asset
  
  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer
  mount_uploader :asset, SiteAssetUploader  
  
  # -- Associations -------------
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :site
  
  # -- Validations --------------
  validates :name, :presence => true
  
  validates :site, :presence => true
            
  validates :asset, :presence => true
  
  # -- Callbacks
  before_save :update_asset_attributes
  before_update :recreate, :if => "self.name_changed?"
    
  def recreate
    self.asset.recreate_versions!
    self.asset_filename = "#{self.name}.#{self.asset.file.extension}"
  end
  
  def update_asset_attributes         
    self.content_type = asset.file.content_type unless asset.file.content_type.nil?
    self.file_size = asset.file.size 
  end  
            
  # -- Instance Methods     
  def image?
    self.asset.image?(self.asset.file)
  end
end
