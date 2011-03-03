class Layout
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :content, :type => String
  embeds_one :created_by, :class_name => "User"
  embeds_one :updated_by, :class_name => "User"
  embedded_in :page, :inverse_of => :layout
end