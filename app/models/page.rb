class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
  include Mongoid::Document::Taggable
  include Mongoid::Tree
  #include Mongoid::Tree::Traversal
  #include Mongoid::Tree::Ordering
  
  attr_accessible :parent_id,
                  :title, 
                  :slug,
                  :breadcrumb, 
                  :meta_title, 
                  :meta_keywords, 
                  :meta_description, 
                  :filter,
                  :current_state, 
                  :permlink,
                  :layout_id,
                  :page_parts,
                  :tag_list,
                  :type
                  
  
  field :title
  field :slug
  field :breadcrumb
  field :meta_title
  field :meta_keywords
  field :meta_description
  field :filter, :type => Filter
  field :type
  
  embeds_one :current_state
  embeds_many :page_parts 
  references_and_referenced_in_many :editors, :class_name => "User"
  referenced_in :layout
  referenced_in :created_by, :class_name => "User"
  referenced_in :updated_by, :class_name => "User"
  
  accepts_nested_attributes_for :current_state
  accepts_nested_attributes_for :page_parts
  
  validates :title,
            :presence => true, 
            :uniqueness => true 
            
  validates :slug,
            :uniqueness => true,
            :allow_blank => true
            
  validates :breadcrumb,
            :uniqueness => true,
            :allow_blank => true
  
  validates :meta_title,
            :uniqueness => true, 
            :allow_blank => true
  
  validates_presence_of :filter, :current_state, :layout, :created_by, :updated_by
  
  after_validation :set_filter, :format_title, :set_slug, :set_breadcrumb, :uniq_editor_ids
  before_save :published_at
  after_save :update_user_pages
  #before_destroy :move_children_to_parent
  
  def published_date
    self.current_state.published_at
  end
  
  def permalink
    year = self.published_date.year.to_s
    month = self.published_date.month.to_s
    day = self.published_date.day.to_s
    year + "/" + month + "/" + day + "/" + self.slug
  end    
  
  def status
    self.current_state.name
  end
  
  private 
  def format_title
    self.title.strip! unless self.title.nil?
  end
  
  def set_filter
    self.filter = Filter.find("html") if self.filter.nil?
  end
  
  def set_slug
    if self.slug.blank?
      self.slug = self.title.downcase
    else
      self.slug.downcase!
      self.slug.strip!
    end
    self.slug.gsub!(/\s/, '-')
  end
  
  def set_breadcrumb
    if self.breadcrumb.blank?
      self.breadcrumb = self.title.downcase
    else
      self.breadcrumb.downcase!
      self.breadcrumb.strip!
    end
  end
  
  def uniq_editor_ids
    self.editor_ids.uniq!
  end
  
  def published_at
    self.current_state.published_at = DateTime.now if self.current_state.name = "published" && self.current_state.published_at.nil?
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
