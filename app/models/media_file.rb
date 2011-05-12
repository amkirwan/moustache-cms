class MediaFile
  include Mongoid::Document
  
  attr_accessible :name, :description, :alt_txt, :media_asset
  
  # -- Fields --------------- 
  field :name
  field :description
  field :alt_txt
  field :media_asset
  
  # -- Associations -------------
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :site
  mount_uploader :media_asset, MediaAssetUploader
  
  # -- Validations --------------
  validates :name,
            :presence => true
end
