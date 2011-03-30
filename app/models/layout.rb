class Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  attr_accessible :layout_id, :name, :content
  
  field :name
  index :name, :unique => true
  field :content
  field :filter, :type => Filter
  
  references_many :pages
  referenced_in :site
  referenced_in :created_by, :class_name => "User"
  referenced_in :updated_by, :class_name => "User"
  
  before_validation :set_filter, :assign_site
  before_save :format_content
  
  validates :name,
            :presence => true,
            :uniqueness => true
            
  validates_presence_of :content, :filter, :created_by_id, :updated_by_id, :site_id
  
  private 
  def set_filter
    self.filter = Filter.find("haml") if self.filter.nil?
  end
  
  def format_content
    self.content.strip!
  end
  
  def assign_site
    self.site_id = Site.first.id
  end
end