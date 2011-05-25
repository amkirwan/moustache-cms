class SiteAsset
  include Mongoid::Document
  
  attr_accessible :name, :description, :content_type, :width, :height, :file_size, :source
  
  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer
  mount_uploader :source, SiteAssetUploader  
  
  # -- Callbacks
  before_save :update_asset_attributes  
  
  def update_asset_attributes         
    self.content_type = source.file.content_type
    self.file_size = source.file.size 
  end
  
  # -- Associations -------------
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :site
  
  # -- Validations --------------
  validates :name,
            :presence => true
  
  validates :site,
            :presence => true
            
  validates :source,
            :presence => true   
            
  # -- Instance Methods     
  def image?
    self.source.image?
  end
end
