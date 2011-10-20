class SiteAsset 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Mongoid::TaggableWithContext

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
  
  # -- Associations 
  embedded_in :asset_collection  
  
  # -- Validations 
  validates :name, :presence => true
            
  validates :asset, :presence => true
  
  # -- Callbacks
  before_save :update_asset_attributes
  before_update :recreate, :if => "self.name_changed?"
  after_destroy :remove_folder  
    
  # -- Instance Methods     
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

  def remove_folder
    FileUtils.rm_rf(File.join(Rails.root, 'public', asset.store_dir))
  end

end
