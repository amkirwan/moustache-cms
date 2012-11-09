class MoustacheCms::ArticleCollection < MoustacheCms::MoustacheCollection::Metal

  attr_accessible :layout_id,
                  :editor_ids,
                  :permalink_prefix

    # -- Fields --------------- 
  field :permalink_prefix, :type => Boolean, :default => false
  
  # -- Associations -------------
  belongs_to :layout, class_name: 'MoustacheCms::Layout'
  created_updated(:article_collections)
  has_many :articles, class_name: 'MoustacheCms::Article'
  has_and_belongs_to_many :editors, class_name: "MoustacheCms::User", inverse_of: :article_collections

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
