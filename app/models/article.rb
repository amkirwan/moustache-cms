class Article 
  include Mongoid::Document 
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  include MoustacheCms::Published
  include Mongoid::TaggableWithContext

  attr_accessible :title,
                  :subheading,
                  :img_url,
                  :permalink,
                  :slug,
                  :content,
                  :current_state, 
                  :current_state_attributes,
                  :meta_tags_attributes,
                  :filter_name,
                  :authors,
                  :layout_id,
                  :tags,
                  :set_date,
                  :date

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
  field :set_date, :type => Boolean
  field :date, :type => Time

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
            :presence => true

  validate :unique_title

  validates :permalink,
            :presence => true

  validate :unique_permalink

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

  def unique_title
    if Article.exists?(:conditions => { :id => { "$ne" => self.id}, :title => /^#{self.title}$/, :article_collection_id => self.article_collection_id, :site_id => self.site_id})
      errors.add(:title, 'within this collection is already taken')
    end
  end

  def unique_permalink
    if Article.exists?(:conditions => { :id => { "$ne" => self.id}, :permalink => /^#{self.permalink}$/, :article_collection_id => self.article_collection_id, :site_id => self.site_id})
      errors.add(:permalink, 'within this collection is already taken')
    end
  end

  # -- Callbacks ----------
  before_validation :format_title, :slug_set, :permalink_set
  before_save :set_date?
  before_update :update_slug_permalink
  after_update :update_current_state_time
  after_initialize :default_meta_tags

  # -- Class Methods --
  def self.article_by_permalink(path)
    self.where(:permalink => path).first
  end


  # -- Instance Methods -----
  alias :full_path :permalink
  alias :full_path= :permalink=

  # -- Accepts_nested -----
  def current_state_attributes=(attributes)
    self.current_state = CurrentState.find_by_name(attributes[:name])
  end

  # This date would is for an associated date like a meeting or event that is distinct from when the article was published or created.
  def datetime
    return "" if self.date.nil?
    self.date.iso8601
  end

  # This returns the associated datetime in words in the format January 06, 2012 at 3pm
  def date_at
    return "" if self.date.nil?
    self.date.strftime("%B %d, %Y at%l%P") 
  end

  private 
    def set_date?
      if !self.set_date
        self.date = nil
      end
    end
    def format_title
      self.title.strip! unless self.title.nil?
    end
    
    def slug_set
      if self.slug.nil? || self.slug.empty? 
        self.slug = self.title.gsub('_', '-')
        self.slug = self.slug.parameterize
      else
        parse_slug(self.slug)
      end
    end

    def permalink_set
      if self.permalink.nil? || self.permalink.blank? 
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
