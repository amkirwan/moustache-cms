class Leaf
  include Mongoid::Document 
  include Mongoid::Timestamps

  include Mongoid::TaggableWithContext

  attr_accessible :site_id,
                  :layout_id, 
                  :title, 
                  :slug,
                  :layout_id,
                  :full_path,
                  :breadcrumb,
                  :current_state, 
                  :current_state_attributes,
                  :meta_tags_attributes,
                  :tags
                  
  # -- Fields -----------------------------
  field :title
  field :slug
  field :full_path
  field :breadcrumb

  taggable

  # -- Associations-------------------------
  embeds_one :current_state
  embeds_many :meta_tags, :as => :meta_taggable
  belongs_to :site
  belongs_to :layout
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  
  accepts_nested_attributes_for :current_state
  accepts_nested_attributes_for :meta_tags

  # -- Validations -----------------------------------------------
  validates :title,
            :presence => true,
            :uniqueness => { :case_sensitive => false, :scope => :site_id }
            
  validates :full_path,
            :presence => true,
            :uniqueness => { :scope => :site_id }

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
  before_validation :format_title, :slug_set, :full_path_set
  before_update :update_current_state_time
  after_initialize :default_meta_tags

  # -- Class Mehtods --------------------------------------------------
  def self.find_by_id(page_id)
    Leaf.find(page_id)
  end
  
  def self.find_by_full_path(full_path)
    self.where(:full_path => full_path).first
  end
  
  def self.find_by_title(title)
    self.where(:title => title).first
  end

  # -- Scopes ----------------------------------------------------------
  scope :published, :where => { "current_state.name" => "published" }
  scope :all_from_current_site, lambda { |current_site| { :where => { :site_id => current_site.id }} }


  # -- Accepts_nested -----
  def current_state_attributes=(attributes)
      self.current_state = CurrentState.find_by_name(attributes[:name])
  end

  # -- Instance Methods -----
  def published?
    self.current_state.published?
  end

  def draft?
    self.current_state.draft?
  end

  def published_on
    self.current_state.published_on
  end  

  def status
    self.current_state.name
  end



# -- Protected Instance Methods -----------------------------------------------
  protected

    def default_meta_tags
      if self.new_record? && self.meta_tags.size == 0
        self.meta_tags.build(:name => "title", :content => "")
        self.meta_tags.build(:name => "keywords", :content => "")
        self.meta_tags.build(:name => "description", :content => "")
      end
    end

    def format_title
      self.title.strip! unless self.title.nil?
    end
    
    # slug is "foobar" in http://example.com/10/02/2011/foobar
    # should override in child
    def slug_set
      if self.slug.blank?
        self.slug = self.title.downcase
      else
        self.slug.downcase!
        self.slug.strip!
      end
    end
  
    # should override in child
    def full_path_set
      self.full_path = self.slug
    end
  
    def update_current_state_time
      self.current_state.time = DateTime.now if self.current_state.changed?
    end
  
end
