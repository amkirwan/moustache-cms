class Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  attr_accessible :name, :content

  #-- Fields -----------------------------------------------  
  field :name
  index :name, unique: true
  field :content
  
  #-- Associations-----------------------------------------------
  has_many :pages
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  
  #-- Validations -----------------------------------------------
  before_save :format_content
  
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }
            
  validates_presence_of :content, :created_by, :updated_by, :site

  #-- Private Instance Methods ----------------------------------
  private 
  
  def format_content
    self.content.strip!
  end
end