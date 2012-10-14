class Page
  include Mongoid::Document 
  include Mongoid::Timestamps
 
  include MoustacheCms::StateSetable
  include MoustacheCms::Published
  include MoustacheCms::DefaultMetaTags
  include MoustacheCms::CreatedUpdatedBy

  include Mongoid::Tree 
  include Mongoid::Tree::Ordering
  include Mongoid::Document::Taggable

  attr_accessible :parent_id,
                  :title, 
                  :slug,
                  :full_path,
                  :breadcrumb,
                  :editor_ids,
                  :layout_id,
                  :page_parts,
                  :page_parts_attributes,
                  :post_container,
                  :custom_fields_attributes,
                  :tag_list
                  
  # -- Fields -----------------------------
  field :title
  field :slug
  field :full_path
  field :breadcrumb

  # -- Index -------------------------------
  index :title => 1
  index :full_path => 1
  
  # -- Associations-------------------------
  embeds_many :custom_fields, :as => :custom_fieldable
  embeds_many :page_parts 
  belongs_to :site
  belongs_to :layout
  created_updated(:pages)
  has_and_belongs_to_many :editors, :class_name => "User", :inverse_of => :pages
  
  accepts_nested_attributes_for :custom_fields
  accepts_nested_attributes_for :page_parts
  
  # -- Validations -----------------------------------------------
  validates :title,
            :presence => true
            
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

  # -- Callbacks -----------------------------------------------
  before_validation :format_title, :slug_set, :full_path_set, :breadcrumb_set
  before_save :uniq_editor_ids, :strip_page_parts
  after_save :update_user_pages
  before_destroy :destroy_children

  # -- Scopes ----------------------------------------------------------
  scope :all_from_current_site, ->(current_site) { where(:site_id => current_site.id) }
  
  # -- Class Mehtods --------------------------------------------------
  def self.find_by_id(page_id)
    self.find(page_id)
  end
  
  def self.find_by_full_path(full_path)
    self.where(:full_path => full_path).first
  end
  
  def self.find_by_title(title)
    self.where(:title => title).first
  end

  def self.find_by_slug(slug)
    self.where(:slug => slug).first
  end

  # -- Instance Methods -----------------------------------------------  
  def home_page?
    self.full_path == '/' ? true : false
  end

  def save_preview
    self.write_attribute(:preview, true)
    self.slug = self.slug + '?preview=true'
    self.save!
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

  def full_path_with_params(params={})
    new_path = self.full_path + '?'
    params.each_pair { |k,v| new_path += (k.to_s + '=' + v.to_s) }
    new_path
  end
  
  # -- Private Instance Methods -----------------------------------------------
  private 
  
    def format_title
      self.title.strip! unless self.title.nil?
    end
    
    # slug is "foobar" in http://example.com/10/02/2011/foobar
    def slug_set
      unless self.title.nil? || self.slug =~ /\?preview=true$/
        if self.site_id.nil?
          self.slug = ""
        elsif self.root?
          set_root_page_slug
        else
          set_child_page_slug
        end
      end
    end

    def set_root_page_slug
      self.parent = nil
      self.title == '404' ? self.slug = '404' : self.slug = '/'
    end

    def set_child_page_slug
      self.slug = self.slug.blank? ? self.title.gsub('_', '-') : self.slug.gsub('_', '-') 

      self.slug = self.slug.parameterize
    end
      
    # full_path is "/foobar/baz/qux" in http://example.com/foobar/baz/qux
    def full_path_set
      self.full_path = self.parent ? "#{self.parent.full_path}/#{self.slug}".squeeze("/") : "/#{self.slug}".squeeze("/")
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

    def strip_page_parts
      self.page_parts.each do |part|
        part.content.strip! unless part.content.nil?
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

