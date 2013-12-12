class ArticleCollection < MoustacheCollection::Metal

  attr_accessible :layout_id,
                  :editor_ids,
                  :permalink_prefix,
                  :commentable

    # -- Fields --------------- 
  field :permalink_prefix, :type => Boolean, :default => false
  field :commentable, type: Boolean, default:  true
  
  validates :layout_id, presence: true
  
  # -- Associations -------------
  belongs_to :layout
  created_updated(:article_collections)
  has_many :articles
  has_and_belongs_to_many :editors, :class_name => "User", :inverse_of => :article_collections

  # -- Class Methods --
  def self.articles_by_collection_name(name)
    article_collection = self.where(:name => name.to_s).first
    article_collection.nil? ? [] : article_collection.articles(:created_at)
  end

  def self.articles_by_collection_name_and_tag(name, tag)
    article_collection = articles_by_collection_name(name)
    article_collection.in(tags: [tag])
  end

  def self.articles_by_collection_name_desc(name)
    article_collection = self.where(:name => name.to_s).first
    article_collection.nil? ? [] : article_collection.articles.desc(:created_at)
  end

end
