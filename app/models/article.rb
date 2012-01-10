class Article 
  include Mongoid::Document 
  include Mongoid::Timestamps

  include HandlebarCms::Published
  include Mongoid::TaggableWithContext

  attr_accessible :title,
                  :subheading,
                  :img_url,
                  :permalink,
                  :slug,
                  :content,
                  :current_state, 
                  :current_state_attributes,
                  :filter_name,
                  :authors,
                  :layout_id,
                  :tags

  # -- Fields -----------
  field :title
  field :subheading
  field :img_url
  field :permalink
  field :slug
  field :content
  field :filter_name
  field :authors, :type => Array
  field :author_ids, :type => Array

  taggable

  # -- Index -----
  index :title
  index :permalink

  # -- Associations -------------
  embeds_one :current_state, :as => :publishable
  embeds_many :meta_tags, :as => :meta_taggable
  belongs_to :site
  belongs_to :article_collection
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :layout, :class_name => "Layout"
  has_and_belongs_to_many :authors

  accepts_nested_attributes_for :current_state
  accepts_nested_attributes_for :meta_tags

  # -- Validations -----------------------------------------------
  validates :site_id,
            :presence => true

  validates :title,
            :presence => true,
            :uniqueness => { :case_sensitive => false, :scope => :article_collection }
            
  validates :permalink,
            :presence => true,
            :uniqueness => { :case_sensitive => false, :scope => :article_collection }

  validates :content,
            :presence => true

  validates :slug,
            :presence => true

  validates :article_collection_id,
            :presence => true

  validates :current_state,
            :presence => true

  validates :created_by_id,
            :presence => true

  validates :updated_by_id,
            :presence => true

  validates :filter_name,
            :presence => true

  # -- Callbacks ----------
  before_validation :format_title, :slug_set, :permalink_set
  before_update :update_slug_permalink
  after_update :update_current_state_time
  after_initialize :default_meta_tags

  # -- Instance Methods -----
  alias :full_path :permalink
  alias :full_path= :permalink=

  # -- Accepts_nested -----
  def current_state_attributes=(attributes)
    self.current_state = CurrentState.find_by_name(attributes[:name])
  end

  private 
    def format_title
      self.title.strip! unless self.title.nil?
    end
    
    def slug_set
      if slug.nil? && self.new_record?
        self.slug = self.title.gsub('_', '-')
        self.slug = self.title.parameterize
      else
        parse_slug(self.slug)
      end
    end

    def permalink_set
      if self.permalink.empty? && self.new_record?
        time = DateTime.now
        year = time.year.to_s
        month = time.month.to_s
        day = time.day.to_s
        collection_name = self.article_collection.name.gsub(/[\s_]/, '-')
        self.permalink = "/#{collection_name.parameterize}/#{year}/#{month}/#{day}/#{self.slug}" 
      end
    end

    def update_slug_permalink
      if self.permalink_changed? 
        permalink_split = self.permalink.split('/')
        parse_slug(permalink_split.pop)
        permalink = permalink_split.join('/')
        permalink.gsub!('_', '-')
        self.permalink = '/' + permalink.parameterize('/') + '/' + self.slug
      end
    end

    def default_meta_tags
      if self.new_record? && self.meta_tags.size == 0
        self.meta_tags.build(:name => "title", :content => "")
        self.meta_tags.build(:name => "keywords", :content => "")
        self.meta_tags.build(:name => "description", :content => "")
      end
    end

    def parse_slug(slug)
      self.slug.gsub!('_', '-')
      self.slug = slug.parameterize
    end

    def update_current_state_time
      self.current_state.time = DateTime.now if self.current_state.changed?
    end
end
