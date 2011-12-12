class Article 
  include Mongoid::Document 
  include Mongoid::Timestamps

  include HandlebarCms::Published
  include Mongoid::TaggableWithContext

  attr_accessible :title,
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
  field :permalink
  field :slug
  field :content
  field :filter_name
  field :authors, :type => Array
  field :author_ids, :type => Array

  taggable

  # -- Associations -------------
  embeds_one :current_state, :as => :publishable
  embeds_many :meta_tags, :as => :meta_taggable
  belongs_to :site
  belongs_to :article_collection
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  belongs_to :layout, :class_name => "Layout"
  has_and_belongs_to_many :authors

  # -- Validations -----------------------------------------------
  validates :site_id,
            :presence => true

  validates :title,
            :presence => true,
            :uniqueness => { :case_sensitive => false, :scope => :article_collection }
            
  validates :permalink,
            :presence => true,
            :uniqueness => { :case_sensitive => false, :scope => :article_collection }

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

  # -- Instance Methods -----
  alias :full_path :permalink
  alias :full_path= :permalink=

  private 
    def format_title
      self.title.strip! unless self.title.nil?
    end
    
    def slug_set
      if slug.blank? 
        self.slug = self.title.downcase
      else
        self.slug.downcase!
        self.slug.strip!
      end
      self.slug.gsub!(/[\s_]/, '-')
    end

    def permalink_set
      if self.permalink.nil?
        time = DateTime.now
        year = time.year.to_s
        month = time.month.to_s
        day = time.day.to_s
        collection_name = self.article_collection.name.gsub(/[\s_]/, '-')
        self.permalink = "/#{collection_name}/#{year}/#{month}/#{day}/#{self.slug}" 
      end
  end
end
