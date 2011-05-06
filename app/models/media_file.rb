class MediaFile
  include Mongoid::Document
  
  # -- Fields --------------- 
  field :name
  field :description
  field :alt_text
  field :caption
  field :local_path
  field :content_type
  
  # -- Associations -------------
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :site
end
