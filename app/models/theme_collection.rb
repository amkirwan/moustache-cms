class ThemeCollection
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::FriendlyFilename
  
  # -- Fields --------------- 
  field :name
  
  # -- Associations -------------
  belongs_to :site
  belongs_to :created_by, :class_name => "User", :inverse_of => :theme_collections_created
  belongs_to :updated_by, :class_name => "User", :inverse_of => :theme_collections_updated
  embeds_many :theme_assets
  
  # -- Validations ---------------
  validates_associated :theme_assets

  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }
            
  validates :site_id,
            :presence => true
            
  validates :created_by_id,
            :presence => true  
            
  validates :updated_by_id,
            :presence => true

  # -- Callbacks
  before_destroy :remove_folder 

  def remove_folder
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', site.id.to_s, name))
  end

end

