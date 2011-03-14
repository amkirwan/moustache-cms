class Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  attr_accessible :name, :content
  
  field :name, :type => String
  index :name, :unique => true
  field :content, :type => String
  field :filter, :type => Filter
  references_many :pages
  #references_many :pages
  referenced_in :created_by, :class_name => "User", :inverse_of => :layouts_created
  referenced_in :updated_by, :class_name => "User", :inverse_of => :layouts_updated
  
  before_validation :set_filter
  
  validates :name,
            :presence => true,
            :uniqueness => true
            
  validates_presence_of :content, :filter, :created_by_id, :updated_by_id
  
  private 
  def set_filter
    self.filter = Filter.find("haml") if self.filter.nil?
  end
end