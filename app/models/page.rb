class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
  include Mongoid::Tree
  #include Mongoid::Tree::Ordering
  include Mongoid::Tree::Traversal
  
  before_destroy :move_children_to_parent
  
  field :title, :type => String
  field :path_name, :type => String
  field :type, :type => String
  field :meta_title, :type => String
  field :meta_keywords, :type => String
  field :meta_description, :type => String
  field :published_at, :type => DateTime
  field :content, :type => String
  embeds_one :filter
  embeds_one :layout
  embeds_one :created_by, :class_name => "User"
  embeds_one :updated_by, :class_name => "User"
end
