class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
  field :name, :type => String
  field :title, :type => String
  field :published_on, :type => DateTime
  field :parent, :type => String
  field :children, :type => Array
  field :meta_title, :type => String
  field :meta_keywords, :type => String
  field :meta_description, :type => String
  field :last_editor, :type => String 
  field :header, :type =>     
  
  
  validates_presence_of :name, :title, :published 
  validates_uniqueness_of :name, :title
end
