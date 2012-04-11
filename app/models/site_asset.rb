class SiteAsset 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Mongoid::TaggableWithContext
  include HandlebarCms::CalcMd5

  attr_accessible :name,
                  :description,
                  :content_type, 
                  :width, 
                  :height, 
                  :file_size, 
                  :asset, 
                  :tags
  
  # -- Fields 
  field :name
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer
  field :creator_id
  field :updator_id
  mount_uploader :asset, SiteAssetUploader  

  taggable
  
  # -- Associations ------
  embedded_in :asset_collection  
  
  # -- Validations -----
  validates :name, :presence => true
  validates :asset, :presence => { :message => "must have a file selected" }
  
  # -- Callbacks
  before_validation :set_name
  before_save :update_asset_attributes
  before_update :recreate
    
  # -- Instance Methods     
  def set_name
    if self.name.strip.empty?
      name_split = self.asset.file.filename.split('.')
      self.name = name_split.slice(0, name_split.length - 1).join('.')
    end
  end

  def recreate
    self.asset.recreate_versions!
  end
 
  def update_asset_attributes         
    self.content_type = asset.file.content_type unless asset.file.content_type.nil?
    self.file_size = asset.file.size 
  end  
         
  def image?
    self.asset.image?(self.asset.file)
  end

end
