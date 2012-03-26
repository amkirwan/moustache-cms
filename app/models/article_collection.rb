class ArticleCollection

  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :name,
                  :layout_id,
                  :editor_ids

    # -- Fields --------------- 
  field :name
  
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

  # -- Class Methods --
  def self.articles_by_name(name)
    self.where(:name => name.to_s).first.articles
  end
end
