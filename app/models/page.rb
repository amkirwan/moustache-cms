class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
  field :name, :type => String
  field :title, :type => String
  field :body, :type => String
  field :published_on, :type => DateTime
  field :parent, :type => String
  field :children, :type => Array
  field :meta_title, :type => String
  field :meta_keywords, :type => String
  field :meta_description, :type => String
  field :last_editor, :type => String     
  embeds_many :people
  
  validates_presence_of :name, :title, :body, :published 
end
