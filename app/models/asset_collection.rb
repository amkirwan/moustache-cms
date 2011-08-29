class AssetCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # -- Fields --------------- 
  field :name
  
  # -- Associations -------------
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  embeds_many :site_assets
  
  # -- Validations ---------------
  validates_associated :site_assets

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
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'assets', site.id, name))
  end

end
