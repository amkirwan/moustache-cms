class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
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
                  :page_parts
  
  field :title, :type => String
  field :path_name, :type => String
  field :meta_title, :type => String
  field :meta_keywords, :type => String
  field :meta_description, :type => String
  field :filter, :type => Filter
  
  embeds_one :current_state
  embeds_many :page_parts 
  references_and_referenced_in_many :editors, :class_name => "User"
  referenced_in :layout
  referenced_in :created_by, :class_name => "User"
  referenced_in :updated_by, :class_name => "User"
  
  accepts_nested_attributes_for :current_state
  
  validates :title,
            :presence => true, :uniqueness => true
            
  validates :path_name,
            :uniqueness => true, :allow_nil => true
  
  validates :meta_title,
            :uniqueness => true, :allow_blank => true, :allow_nil => true
  
  validates_presence_of :filter, :current_state, :layout, :created_by, :updated_by
  
  before_validation :set_filter, :format_title, :set_path_name, :uniq_editor_ids
  after_save :update_user_pages
  #before_destroy :move_children_to_parent
  
  private 
  def format_title
    self.title.strip! unless self.title.nil?
  end
  
  def set_filter
    self.filter = Filter.find("html") if self.filter.nil?
  end
  
  def set_path_name
    if self.path_name.nil? && !self.title.nil?
      self.path_name = self.title
    else
      self.path_name = self.path_name.strip!
    end
  end
  
  def uniq_editor_ids
    self.editor_ids.uniq!
  end
  
  ## rc7 temp fixes for relations for mongoid
  def update_user_pages
    self.editors.each do |editor|
      editor.page_ids ||= []
      editor.pages << self unless editor.pages.include?(self)
      editor.save
    end
  end
end
