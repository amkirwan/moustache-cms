class Page < Leaf
  include Mongoid::Document 
  include Mongoid::Timestamps
 
  include Mongoid::Tree 
  include Mongoid::Tree::Ordering

  attr_accessible :parent_id,
                  :page_parts,
                  :page_parts_attributes,
                  :post_container,
                  :meta_tags_attributes
                  
  # -- Fields -----------------------------
  field :post_container, :type => Boolean, :default => false    

  # -- Index -------------
  index :title
  index :full_path
  
  # -- Associations--------
  embeds_many :page_parts 
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  has_and_belongs_to_many :editors, :class_name => "User"
  
  accepts_nested_attributes_for :page_parts

  # -- Callbacks -----------
  after_save :update_user_pages
  #before_destroy :destroy_children
  
  # -- Instance Methods -----
  def home_page?
    self.full_path == '/' ? true : false
  end

  def sort_children(page_ids)
    page_ids.each_with_index do |id, index|
      child = self.children.find(id)
      child.position = index
      child.save
    end
  end

  # -- Private ---------
  private 

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

    #rc7 temp fixes for relations for mongoid
    def update_user_pages
      self.editors.each do |editor|
        editor.page_ids ||= []
        editor.page_ids << self.id unless editor.page_ids.include?(self)
        editor.save
      end
    end
  
end
