class Site
  include Mongoid::Document
  include Mongoid::Timestamps 
  
  attr_accessible :name, :subdomain, :domain_names, :meta_tags_attributes
  
  field :name
  field :subdomain
  field :default_domain
  field :domain_names, :type => Array, :default => []
  
  # -- Index ---------------------------------------
  index :domain_names
  
  # -- Associations ---------------------------------------
  embeds_many :meta_tags, :as => :meta_taggable
  has_many :users, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_many :layouts, :dependent => :destroy
  has_many :asset_collections, :dependent => :destroy
  has_many :theme_assets, :dependent => :destroy
  has_many :snippets, :dependent => :destroy
  has_many :authors, :dependent => :destroy
  has_many :articles, :dependent => :destroy
    
  accepts_nested_attributes_for :meta_tags

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
  after_initialize :default_meta_tags
            
  # -- Scopes ---------------------------------------
  scope :match_domain, lambda { |domain| { :any_in => { :domain_names => [*domain] }} }
 
  # -- Instance Methods ----------------------------------------
  def full_subdomain
    "#{self.subdomain}.#{self.default_domain}"
  end
  
  def add_subdomain_to_domain_names
    self.domain_names ||= []
    if self.subdomain_changed? || self.default_domain_changed?
      if self.subdomain_was.nil?
        self.domain_names << self.full_subdomain
      else
        domain_names.delete(old_domain) if domain_names.include?(old_domain)
        (self.domain_names << self.full_subdomain).uniq!
      end
    else
      (self.domain_names << self.full_subdomain).uniq!
   end
  end
  
  def add_full_subdomain(domain)
    (domain_names << domain).uniq!
  end
  
  def page_by_full_path(path)   
    pages.where(:full_path => path).first
  end
  
  def page_by_title(title)  
    pages.where(:title => title).first
  end
  
  def css_files        
    theme_assets.css_files(self)
  end
  
  def css_file_by_name(name)
    ThemeAsset.where(:name => name, :site_id => self.id, :content_type => "text/css").first
  end 
  
  def snippet_by_name(name)                        
    Snippet.find_by_site_and_name(self, name).first
  end
  
  private  
    def old_domain
      "#{self.subdomain_was}.#{self.default_domain_was}"
    end

    def default_meta_tags
      if self.new_record? && self.meta_tags.size == 0
        self.meta_tags.build(:name => "title", :content => "")
        self.meta_tags.build(:name => "keywords", :content => "")
        self.meta_tags.build(:name => "description", :content => "")
      end
    end

end
