class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
  include Mongoid::Document::Taggable
  include Mongoid::Tree
  #include Mongoid::Tree::Traversal
  #include Mongoid::Tree::Ordering

  attr_accessible :site,
                  :parent,
                  :title, 
                  :slug,
                  :full_path,
                  :permalink,
                  :breadcrumb,
                  :meta_title, 
                  :meta_keywords, 
                  :meta_description, 
                  :current_state, 
                  :layout_id,
                  :page_parts,
                  :tag_list
                  
  # -- Fields -----------------------------------------------
  field :title
  field :slug
  field :full_path
  field :permalink
  field :breadcrumb
  field :meta_title
  field :meta_keywords
  field :meta_description
  field :type
  field :template
  
  # -- Associations-----------------------------------------------
  referenced_in :site
  embeds_one :current_state
  embeds_many :page_parts 
  belongs_to :layout
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  has_and_belongs_to_many :editors, :class_name => "User"
  
  accepts_nested_attributes_for :current_state
  accepts_nested_attributes_for :page_parts
  
  # -- Validations -----------------------------------------------
  validates :title,
            :presence => true, 
            :uniqueness => { :scope => :site_id }

  validates :meta_title,
            :uniqueness => true, 
            :allow_blank => true
            
  validates :full_path,
            :presence => true,
            :uniqueness => { :scope => :site_id }

  validates :breadcrumb,
            :presence => true
  
  validates_presence_of :site,
                        :slug, 
                        :current_state,
                        :layout, 
                        :created_by, 
                        :updated_by                    
  
  # -- Callbacks -----------------------------------------------
  before_validation :format_title, :slug_set, :full_path_set, :breadcrumb_set, :site_set
  before_save :uniq_editor_ids
  before_update :update_current_state_time
  after_save :update_user_pages
  before_destroy :delete_from_editors, :move_children_to_parent
  
  # -- Class Mehtods --------------------------------------------------
  def self.find_by_full_path(site, full_path)
    self.where(:site_id => site.id, :full_path => full_path).first
  end

  #-- Scopes ----------------------------------------------------------
  scope :published, :where => { "current_state.name" => "published" }

  # -- Instance Methods -----------------------------------------------  
  def published?
    self.current_state.published?
  end
  
  def draft?
    self.current_state.draft?
  end
  
  def published_at
    self.current_state.published_at
  end
  
  def permalink
    year = self.published_at.year.to_s
    month = self.published_at.month.to_s
    day = self.published_at.day.to_s
    year + "/" + month + "/" + day + "/" + self.slug
  end    
  
  def status
    self.current_state.name
  end
  
  # -- Private Instance Methods -----------------------------------------------
  private 
  def format_title
    self.title.strip! unless self.title.nil?
  end
    
  def slug_set
    if Page.root.nil?
      self.slug = "/"
      self.parent = nil
    elsif self.slug.blank?
      self.slug = self.title.downcase
    else
      self.slug.downcase!
      self.slug.strip!
    end
    self.slug.gsub!(/\s/, '-')
  end
  
  def full_path_set
    self.full_path = self.parent ? "#{self.parent.full_path}/#{self.slug}".squeeze("/") : "/"
  end
  
  def breadcrumb_set
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
  
  def update_current_state_time
    self.current_state.time = DateTime.now
  end
  
  def site_set
    self.site = Site.first
  end
  
  #rc7 temp fixes for relations for mongoid
  def update_user_pages
    self.editors.each do |editor|
      editor.page_ids ||= []
      editor.page_ids << self.id unless editor.page_ids.include?(self)
      editor.save
    end
  end
  
  def delete_from_editors
    self.editors.each do |editor| 
      editor.page_ids.delete(self.id)
      editor.save
    end  
  end
end
