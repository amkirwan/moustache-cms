class MediaFile
  include Mongoid::Document
  
  attr_accessible :name, :description, :alt_text, :media_asset
  
  # -- Fields --------------- 
  field :name
  field :description
  field :alt_text
  field :media_asset
  
  # -- Associations -------------
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :site
  mount_uploader :media_asset, MediaAssetUploader
end
