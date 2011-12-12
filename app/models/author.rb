class Author
  include Mongoid::Document 
  include Mongoid::Timestamps

  attr_accessible :prefix,
                  :firstname,
                  :middlename,
                  :lastname,
                  :image,
                  :profile

  # -- Fields ------
  field :prefix
  field :firstname
  field :middlename
  field :lastname
  field :profile
  mount_uploader :image, AuthorUploader

  # -- Associations ---
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  has_and_belongs_to_many :articles

  # -- Callbacks ---
  before_save :strip_whitespace

  def full_name
    if self.middlename.empty?
      self.firstname.capitalize + ' ' + self.lastname.capitalize
    else
      self.firstname.capitalize + ' ' + self.middlename.capitalize + ' ' + self.lastname.capitalize
    end
  end

  def articles
    collection = ArticleCollection.where(:site_id => site.id)
    articles = []
    collection.each do |ac|
      ac.articles.each do |article|
        art = article.where(:article_ids => self.id).first
        unless art.nil? 
          articles << art
        end
      end
    end
    articles  
  end

  private 
    def strip_whitespace
      self.firstname.strip!
      self.middlename.strip!
      self.lastname.strip!
    end
end
