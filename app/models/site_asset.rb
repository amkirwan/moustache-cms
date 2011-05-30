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
  
  # -- Associations -------------
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :site
  
  # -- Callbacks
  before_save :update_asset_attributes
  before_update :recreate, :if => "self.name_changed?"
    
  def recreate
    self.source.recreate_versions!
    self.source_filename = "#{self.name}.#{self.source.file.extension}"
  end
  
  def update_asset_attributes         
    self.content_type = source.file.content_type unless source.file.content_type.nil?
    self.file_size = source.file.size 
  end
  
  # -- Validations --------------
  validates :name,
            :presence => true
  
  validates :site,
            :presence => true
            
  validates :source,
            :presence => true   
            
  # -- Instance Methods     
  def image?
    self.source.image?(self)
  end
end
