class MoustacheCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include MoustacheCms::Siteable
  include MoustacheCms::FriendlyFilename
  include MoustacheCms::Collectable

  attr_accessible :name

  # -- Field --
  field :name

  # -- Index -----
  index :name => 1

  # -- Validations ---------------
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }
            
  class Metal < MoustacheCollection
    include MoustacheCms::CreatedUpdatedBy
  end
   
end
