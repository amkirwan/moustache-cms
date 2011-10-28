class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
 
  include Mongoid::Tree 
  include Mongoid::Tree::Ordering
  include Mongoid::TaggableWithContext

  attr_accessible :parent_id,
                  :render_tag,
                  :title, 
                  :slug,
                  :full_path,
                  :permalink,
                  :breadcrumb,
                  :editor_ids,
                  :current_state, 
                  :current_state_attributes,
                  :layout_id,
                  :page_parts,
                  :page_parts_attributes,
                  :post_container,
                  :meta_tags_attributes,
                  :tags
                  
  # -- Fields -----------------------------------------------
  field :render_tag
  field :title
  field :slug
  field :full_path
  field :permalink
  field :breadcrumb
  field :post_container, :type => Boolean, :default => false    

  taggable
  
  # -- Associations-----------------------------------------------
  embeds_one :current_state
  embeds_many :meta_tags, :as => :meta_taggable
  embeds_many :page_parts 
  belongs_to :site
  belongs_to :layout
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  has_and_belongs_to_many :editors, :class_name => "User"
  
  accepts_nested_attributes_for :current_state
  accepts_nested_attributes_for :meta_tags
  accepts_nested_attributes_for :page_parts
  
  # -- Validations -----------------------------------------------
  validates :render_tag,
            :uniqueness => { :scope => :site_id, :allow_blank => true }
            
  validates :title,
            :presence => true,
            :uniqueness => { :case_sensitive => false, :scope => :site_id }
            
  validates :full_path,
            :presence => true,
            :uniqueness => { :scope => :site_id }

  validates :breadcrumb,
            :presence => true

  validates_presence_of :site_id,
                        :slug, 
                        :current_state,
                        :layout_id, 
                        :created_by_id, 
                        :updated_by_id                    

  validate :site_id_match_create, :on => :create unless Rails.env == "test"
  validate :site_id_match_update, :on => :update unless Rails.env == "test"

  # protect against creating a page in a site the user does not have permission to
  def site_id_match_create
    unless User.find(created_by_id).site_id == site_id && User.find(updated_by_id).site_id == site_id
      errors.add(:site_id, "The pages site_id must match the users site_id")
    end
  end

  def site_id_match_update
    unless User.find(updated_by_id).site_id == site_id
      errors.add(:site_id, "The pages site_id must match the users site_id")
    end
  end
  
  # -- Callbacks -----------------------------------------------
  before_validation :format_title, :slug_set, :full_path_set, :breadcrumb_set, :format_render_tag
  before_save :uniq_editor_ids
  before_update :update_current_state_time
  before_create :permalink_set
  after_save :update_user_pages
  #before_destroy :destroy_children
  after_initialize :default_meta_tags
  
  # -- Class Mehtods --------------------------------------------------
  def self.find_by_id(page_id)
    Page.find(page_id)
  end
  
  def self.find_by_full_path(full_path)
    self.where(:full_path => full_path).first
  end
  
  def self.find_by_title(title)
    self.where(:title => title).first
  end
  
  def self.find_by_render_tag(name)
    self.where(:render_tag => name).first
  end

  # -- Scopes ----------------------------------------------------------
  scope :published, :where => { "current_state.name" => "published" }


  # -- Accepts_nested -----
  def current_state_attributes=(attributes)
      self.current_state = CurrentState.find_by_name(attributes[:name])
  end

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
  
  def status
    self.current_state.name
  end
  
  def delete_association_of_editor_id(editor_id)
    editor = User.find(editor_id)
    self.editor_ids.delete(editor.id)
    editor.page_ids.delete(self.id)
    editor.save
  end

  def sort_children(page_ids)
    page_ids.each_with_index do |id, index|
      child = self.children.find(id)
      child.position = index
      child.save
    end
  end
  
  # -- Private Instance Methods -----------------------------------------------
  private 

    def default_meta_tags
      if self.new_record? && self.meta_tags.size == 0
        self.meta_tags.build(:name => "title", :content => "")
        self.meta_tags.build(:name => "keywords", :content => "")
        self.meta_tags.build(:name => "description", :content => "")
      end
    end

    def format_render_tag
      #self.name.strip! unless self.name.nil?
      if !self.render_tag.nil?
        self.render_tag.strip!
        self.render_tag.downcase!
        self.render_tag.gsub!(/\s/, '_')
      end
    end
    
    def format_title
      self.title.strip! unless self.title.nil?
    end
    
    # slug is "foobar" in http://example.com/10/02/2011/foobar
    def slug_set
      if self.site_id.nil?
        self.slug = ""
      elsif self.title == "404"
        self.slug = "404"
      elsif self.root?
        self.slug = "/"
        self.parent = nil
      elsif self.slug.blank?
        self.slug = self.title.downcase
      else
        self.slug.downcase!
        self.slug.strip!
      end
      self.slug.gsub!(/[\s_]/, '-')
    end
  
    # full_path is "/foobar/baz/qux" in http://example.com/foobar/baz/qux
    def full_path_set
      if self.slug == "404"
        self.full_path = "404"
      else
        self.full_path = self.parent ? "#{self.parent.full_path}/#{self.slug}".squeeze("/") : "/"
      end
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
      self.current_state.time = DateTime.now if self.current_state.changed?
    end
  
    def permalink_set
      if self.parent.try(:post_container)
        time = DateTime.now
        year = time.year.to_s
        month = time.month.to_s
        day = time.day.to_s
        self.permalink = "http://#{self.site.full_subdomain}/#{year}/#{month}/#{day}/#{self.slug}"
      else
        permalink = nil
      end
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
