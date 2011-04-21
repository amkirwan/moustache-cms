class Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  attr_accessible :layout_id, :name, :content

  #-- Fields -----------------------------------------------  
  field :name
  index :name, unique: true
  field :content
  
  #-- Associations-----------------------------------------------
  references_many :pages
  referenced_in :site
  referenced_in :created_by, :class_name => "User"
  referenced_in :updated_by, :class_name => "User"
  
  #-- Validations -----------------------------------------------
  before_validation :site_set
  before_save :format_content
  
  validates :name,
            :presence => true,
            :uniqueness => true
            
  validates_presence_of :content, :created_by_id, :updated_by_id, :site_id

  #-- Private Instance Methods ----------------------------------
  private 
  
  def format_content
    self.content.strip!
  end
  
  def site_set
    self.site = Site.first
  end
end