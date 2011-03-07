class Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  attr_accessible :name, :content
  
  field :name, :type => String
  field :content, :type => String
  field :default, :type => Boolean 
  embeds_one :created_by, :class_name => "User"
  embeds_one :updated_by, :class_name => "User"
  embedded_in :page, :inverse_of => :layout
  
  validates :name,
            :presence => true,
            :uniqueness => true
            
  validates_presence_of :content, :created_by, :updated_by
  validates_associated :created_by, :updated_by
end