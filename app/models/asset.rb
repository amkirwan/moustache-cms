class Asset
  include Mongoid::Document
  
  attr_accessible :name, :content_type, :width, :height, :size, :source
  
  # -- Fields --------------- 
  field :name, :type => String
  field :content_type, :type => String
  field :width, :type => Integer
  field :height, :type => Integer
  field :size, :type => Integer
  mount_uploader :source, AssetUploader
  
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
end
