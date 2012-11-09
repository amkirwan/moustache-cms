class MoustacheCms::MoustacheCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include MoustacheCms::FriendlyFilename
  include MoustacheCms::Collectable

  attr_accessible :name

  # -- Field --
  field :name

  # -- Associations ----
  belongs_to :site, class_name: 'MoustacheCms::Site' 

  # -- Validations ---------------
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }
            
  validates :site_id,
            :presence => true

  class Metal < MoustacheCms::MoustacheCollection
    include MoustacheCms::CreatedUpdatedBy
  end
   
end
