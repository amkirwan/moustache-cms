class Site
  include Mongoid::Document
  include Mongoid::Timestamps 

  include MoustacheCms::DefaultMetaTags
  
  attr_accessible :name, :subdomain, :domain_names, :default_domain
  
  field :name
  field :subdomain
  field :default_domain
  field :domain_names, :type => Array, :default => []
  
  # -- Index ---------------------------------------
  index({ domain_names: 1 }, { unique: true })
  
  # -- Associations ---------------------------------------
  has_many :users, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_many :layouts, :dependent => :destroy
  has_many :asset_collections, :dependent => :destroy
  has_many :snippets, :dependent => :destroy
  has_many :authors, :dependent => :destroy
  has_many :article_collections, :dependent => :destroy
  has_many :articles, :dependent => :destroy
  has_many :theme_collections, :dependent => :destroy
  has_many :moustache_assets 
    

  # -- Validations ----------------------------------------
  validates :name,
            :presence => true,
            :uniqueness => true
  validates :default_domain,
            :presence => true
  validates :subdomain,
            :presence => true,
            :uniqueness => true
            
  # -- Callbacks -----------------------------------------------
  before_save :add_subdomain_to_domain_names
            
  # -- Scopes ---------------------------------------
  scope :match_domain, ->(domain) { any_in(:domain_names => [*domain]) }
 
  # -- Instance Methods ----------------------------------------
  def homepage
    self.pages.find_homepage(self)
  end
  def full_subdomain
    "#{self.subdomain}.#{self.default_domain}"
  end
  
  def add_subdomain_to_domain_names
    self.domain_names ||= []
    if domain_names.include?(old_domain)
      domain_names.delete(old_domain)
    end
    (self.domain_names << self.full_subdomain).uniq!
  end

  def add_full_subdomain(domain)
    (domain_names << domain).uniq!
  end

  alias :add_domain :add_full_subdomain

  def find_page(id)
    self.pages.find(id)
  end
  
  def page_by_full_path(path)   
    self.pages.find_by_full_path(path)
  end
  
  def page_by_title(title)  
    self.pages.find_by_title(title)
  end
 
  def article_by_permalink(path)
    self.articles.article_by_permalink(path)
  end

  def article_collection_by_name(name)
    self.article_collections.where(:name => name)
  end

  def articles_by_collection_name(name)
    self.article_collections.articles_by_collection_name(name)
  end

  def articles_by_collection_name_desc(name)
    self.article_collections.articles_by_collection_name_desc(name)
  end
  
  def snippet_by_name(name)                        
    self.snippets.snippet_by_name(name)
  end

  def css_files        
    css_files = []
    self.theme_collections.each do |tc|
      css_files << tc.theme_assets.css_files.to_a
    end
    css_files.flatten
  end
  
  def theme_css_file_by_name(theme_name, css_name)
    theme_collection = theme_collection_by_name(theme_name)
    theme_collection.theme_assets.css_files.where(:name => css_name).first
  end 

  def theme_js_file_by_name(theme_name, js_name)
    theme_collection = theme_collection_by_name(theme_name)
    theme_collection.theme_assets.js_files.where(:name => js_name).first
  end 
  
  def theme_image_file_by_name(theme_name, image_name)
    theme_collection = theme_collection_by_name(theme_name)
    theme_collection.theme_assets.images.where(:name => image_name).first
  end

  def site_asset_by_name(asset_collection, file_name)
    asset_collection = AssetCollection.where(:name => asset_collection, :site_id => self.id).first
    asset_collection.site_assets.where(:name => file_name).first
  end

  def theme_collection_by_name(theme_name)
    ThemeCollection.where(:name => theme_name, :site_id => self.id).first
  end

  def meta_tag_by_name(name)
    self.meta_tags.where(:name => name).first
  end

  def admin_page_path
    self.subdomain + '.' + self.default_domain + '/admin'
  end
  
  private  
    def old_domain
      "#{self.subdomain_was}.#{self.default_domain_was}"
    end

end
