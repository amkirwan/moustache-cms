class MoustacheAsset
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::CalcMd5

  attr_accessible :name,
                  :description,
                  :content_type,
                  :width,
                  :height,
                  :file_size,
                  :asset

  # -- Fields ---
  field :name
  field :content_type
  field :width, type: Integer
  field :height, type: Integer
  field :file_size, type: Integer
  field :creator_id
  field :updator_id
  field :asset
  field :site_id, type: Moped::BSON::ObjectId

  mount_uploader :asset, BaseAssetUploader 

  validates :name, :presence => true 
  validates :asset, :presence => { :message => "must have a file selected" }

  # -- Index ---------------------------------------
  index :name => 1

  # -- Callbacks
  before_validation :set_name
  before_save :update_asset_attributes
  before_update :recreate

  %w{image stylesheet javascript}.each do |type|
    define_method("#{type}?") do
      self.asset.send("#{type}?")
    end
  end

  def url
    asset.url
  end

  protected

  def set_name
    if self.name.blank?
      self.name = self.asset.file.filename
    end
  end
  
  def update_asset_attributes         
    self.content_type = asset.file.content_type unless asset.file.content_type.nil?
    self.file_size = asset.file.size 
  end  

  def recreate
    self.asset.recreate_versions!
  end

end
