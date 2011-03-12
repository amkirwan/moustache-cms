class Page
  include Mongoid::Document 
  #include Mongoid::Timestamps
  #include Mongoid::Tree
  #include Mongoid::Tree::Traversal
  #include Mongoid::Tree::Ordering
  
  field :title, :type => String
  field :path_name, :type => String
  field :meta_title, :type => String
  field :meta_keywords, :type => String
  field :meta_description, :type => String
  field :filter, :type => Filter
  embeds_one :current_state
  referenced_in :layouts
  referenced_in :created_by, :class_name => "User"
  referenced_in :updated_by, :class_name => "User"
  #embeds_many :page_parts 
  accepts_nested_attributes_for :current_state
  accepts_nested_attributes_for :layouts
  
  before_validation :set_filter
  #before_destroy :move_children_to_parent
  
  private 
  def set_filter
    self.filter = Filter.find("html") if self.filter.nil?
  end
end
