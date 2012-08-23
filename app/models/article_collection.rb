class ArticleCollection
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::FriendlyFilename

  attr_accessible :name,
                  :layout_id,
                  :editor_ids,
                  :permalink_prefix

    # -- Fields --------------- 
  field :name
  field :permalink_prefix, :type => Boolean
  
  # -- Associations -------------
  belongs_to :site
  belongs_to :layout
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  has_many :articles
  has_and_belongs_to_many :editors, :class_name => "User", :inverse_of => :article_collections

  # -- Validations -------
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }

  validates :site_id,
            :presence => true

  validates :created_by_id,
            :presence => true

  validates :updated_by_id,
            :presence => true

  after_initialize do |ac|
    ac.permalink_prefix = false if ac.permalink_prefix.nil?
  end

  # -- Class Methods --
  def self.articles_by_collection_name(name)
    article_collection = self.where(:name => name.to_s).first
    article_collection.nil? ? [] : article_collection.articles(:created_at)
  end

  def self.articles_by_collection_name_desc(name)
    article_collection = self.where(:name => name.to_s).first
    article_collection.nil? ? [] : article_collection.articles.desc(:created_at)
  end

end
