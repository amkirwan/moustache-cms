class BaseCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include MoustacheCms::FriendlyFilename
  include MoustacheCms::AssetCollectable

  attr_accessible :name

  # -- Field --
  field :name

  # -- Associations -------------
  belongs_to :site

  # -- Callbacks ---
  before_destroy :remove_folder 

  # -- Validations ---------------
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }
            
  validates :site_id,
            :presence => true
   
end
