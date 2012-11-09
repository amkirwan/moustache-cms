class MoustacheCms::Snippet
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_accessible :name, :content, :filter_name
  # -- Fields ----
  field :name
  field :content
  field :filter_name
                   
  # -- Assocations ----
  belongs_to :site, class_name: 'MoustacheCms::Site' 
  belongs_to :created_by, class_name: 'MoustacheCms::User', inverse_of: :snippets_created
  belongs_to :updated_by, class_name: 'MoustacheCms::User', inverse_of: :snippets_updated

  # accepts_nested_attributes_for :filter        
  
  # -- Validations ----
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }   
  validates :site,
            :presence => true
  validates :filter_name,
            :presence => true
  validates :created_by_id,
            :presence => true
  validates :updated_by_id,
            :presence => true
            
  #-- Scopes ----      
  scope :find_by_site_and_name, ->(site, name) { where(:name => name, :site_id => site.id) }

  #-- Class Methods --
  def self.snippet_by_name(name)
    self.where(:name => name.to_s).first
  end

end
