class Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  attr_accessible :name, :content
  
  field :name, :type => String
  field :content, :type => String
  field :default, :type => Boolean 
  embeds_one :filter
  embeds_one :created_by, :class_name => "User"
  embeds_one :updated_by, :class_name => "User"
  embedded_in :page, :inverse_of => :layout
  
  before_create :set_filter
  before_save :set_filter 
  
  validates :name,
            :presence => true,
            :uniqueness => true
            
  validates_presence_of :content, :filter, :created_by, :updated_by
  validates_associated :created_by, :updated_by
  
  private 
  def set_filter
    self.filter = Filter.find("haml") unless self.filter.nil?
  end
end