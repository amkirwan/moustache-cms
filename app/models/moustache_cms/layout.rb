class MoustacheCms::Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  attr_accessible :name, :content

  #-- Fields -----------------------------------------------  
  field :name
  field :content

  # -- Index -------------------------------
  index :name => 1
  
  #-- Associations-----------------------------------------------
  has_many :pages, class_name: 'MoustacheCms::Page', dependent: :nullify
  has_many :article_collections, class_name: 'MoustacheCms::ArticleCollection' 
  has_many :articles, class_name: 'MoustacheCms::Article'
  belongs_to :site, class_name: 'MoustacheCms::Site' 
  belongs_to :created_by, class_name: 'MoustacheCms::User', inverse_of: :layouts_created
  belongs_to :updated_by, class_name: 'MoustacheCms::User', inverse_of: :layouts_updated
  
  #-- Validations -----------------------------------------------
  before_save :format_content
  
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }
            
  validates_presence_of :content, :created_by_id, :updated_by_id, :site_id

  # -- Scopes ----
  scope :all_from_current_site, ->(current_site) { where(:site_id => current_site.id) }

  #-- Private Instance Methods ----------------------------------
  private 
  
  def format_content
    self.content.strip!
  end
end
