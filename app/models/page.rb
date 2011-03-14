class Page
  include Mongoid::Document 
  #include Mongoid::Timestamps
  #include Mongoid::Tree
  #include Mongoid::Tree::Traversal
  #include Mongoid::Tree::Ordering
  
  attr_accessible :title, 
                  :path_name, 
                  :meta_title, 
                  :meta_keywords, 
                  :meta_description, 
                  :filter,
                  :current_state, 
                  :layout_id
  
  field :title, :type => String
  field :path_name, :type => String
  field :meta_title, :type => String
  field :meta_keywords, :type => String
  field :meta_description, :type => String
  field :filter, :type => Filter
  embeds_one :current_state
  referenced_in :layout
  referenced_in :created_by, :class_name => "User", :inverse_of => :pages_created
  referenced_in :updated_by, :class_name => "User", :inverse_of => :pages_updated
  #embeds_many :page_parts 
  accepts_nested_attributes_for :current_state
  
  validates :title,
            :presence => true,
            :uniqueness => true
            
  validates :path_name,
            :presence => true,
            :uniqueness => true
  
  validates :meta_title,
            :uniqueness => true, :allow_blank => true, :allow_nil => true
  
  validates_presence_of :filter, :current_state, :layout, :created_by, :updated_by
  
  before_validation :set_filter
  #before_destroy :move_children_to_parent
  
  private 
  def set_filter
    self.filter = Filter.find("html") if self.filter.nil?
  end
end
