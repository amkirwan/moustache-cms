class Article 
  include Mongoid::Document 
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  include MoustacheCms::Siteable
  include MoustacheCms::StateSetable
  include MoustacheCms::Published
  include MoustacheCms::DefaultMetaTags

  include Mongoid::Document::Taggable

  attr_accessible :title,
                  :subheading,
                  :img_url,
                  :permalink,
                  :slug,
                  :content,
                  :filter_name,
                  :author_ids,
                  :layout_id,
                  :tag_list,
                  :set_date,
                  :date,
                  :commentable

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
  field :commentable, type: Boolean, default: true

  # -- Index -----
  index :title => 1
  index :permalink => 1

  # -- Associations -------------
  belongs_to :article_collection
  belongs_to :created_by, :class_name => "User", :inverse_of => :articles_created
  belongs_to :updated_by, :class_name => "User", :inverse_of => :articles_updated
  belongs_to :layout, :class_name => "Layout"
  has_and_belongs_to_many :authors
  embeds_many :comments

  accepts_nested_attributes_for :authors

  # -- Validations -----------------------------------------------
  validates :title,
            :presence => true

  validates :permalink,
            :presence => true,
            :uniqueness => { :scope => :site_id, :message => "must be unique. %{value} is used by another article in this site." }

  validates :slug,
            :presence => true

  validates :article_collection_id,
            :presence => true

  validates :created_by_id,
            :presence => true

  validates :updated_by_id,
            :presence => true

  validates :filter_name,
            :presence => true

  # -- Callbacks ----------
  before_validation :format_title, :slug_set, :permalink_set
  before_save :set_date?
  before_update :update_slug_permalink

  # -- Class Methods --
  def self.article_by_permalink(path)
    self.where(:permalink => path).first
  end

  # -- Instance Methods -----
  alias_method :full_path, :permalink
  alias_method :full_path=, :permalink=

  def save_preview
    self.write_attribute(:preview, true)
    self.slug = self.slug + '?preview=true'
    self.permalink = self.permalink + '?preview=true'
    self.save
  end

  # This date is for an associated date like a meeting or event that is distinct from when the article was published or created.
  def datetime
    return "" if self.date.nil?
    self.date.iso8601
  end

  def date_at_with_time
    return "" if self.date.nil?
    self.date.strftime("%B %d, %Y at%l%P")
  end

  def date_at
    return "" if self.date.nil?
    self.date.strftime("%B %d, %Y")
  end

  def date_at_time_only
    return "" if self.date.nil?
    self.date.strftime("%l%P")
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
      elsif self.slug =~ /\?preview=true$/
        self.slug = self.slug
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
        collection_name = self.article_collection.name.gsub(/[^a-z0-9\-]+/, '-')
        if self.article_collection.permalink_prefix?
          self.permalink = "/#{collection_name}/#{year}/#{month}/#{day}/#{self.slug}" 
        else
          self.permalink = "/#{year}/#{month}/#{day}/#{self.slug}" 
        end
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

    def parse_slug(slug)
      self.slug.gsub!('_', '-')
      self.slug = slug.parameterize
    end

end
