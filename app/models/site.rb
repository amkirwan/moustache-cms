class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  include Etherweb::Mongoid::MetaData
  
  attr_accessible :name, :subdomain, :meta_data
  
  field :name
  key :name
  field :subdomain
  field :default_domain
  field :domains, type: Array, default: []
  
  # -- Index ---------------------------------------
  index :domains
  
  # -- Associations ---------------------------------------
  has_many :pages, :dependent => :delete
  has_many :layouts, :dependent => :delete
  has_many :asset_collections, :dependent => :delete
  has_many :theme_assets, :dependent => :delete
  has_many :users, :dependent => :delete  
  has_many :snippets, :dependent => :delete

    
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
  before_save :add_subdomain_to_domains
            
  # -- Scopes ---------------------------------------
  scope :match_domain, lambda { |domain| { :any_in => { :domains => [*domain] }} }
 
  # -- Instance Methods ----------------------------------------
  def full_subdomain
    "#{self.subdomain}.#{self.default_domain}"
  end
  
  def add_subdomain_to_domains
    self.domains ||= []
    if self.subdomain_changed? || self.default_domain_changed?
      if self.subdomain_was.nil?
        self.domains << self.full_subdomain
      else
        domains.delete(old_domain) if domains.include?(old_domain)
        (self.domains << self.full_subdomain).uniq!
      end
    end
  end
  
  def add_full_subdomain(domain)
    (domains << domain).uniq!
  end
  
  def page_by_full_path(path)
    pages.where(:full_path => path).first
  end
  
  def page_by_name(name)
    pages.where(:name => name).first
  end
  
  def css_files
    theme_assets.css_files(self)
  end
  
  def css_file_by_name(name)
    ThemeAsset.where(:name => name, :site_id => self.id, :content_type => "text/css").first
  end
  
  private  
    def old_domain
      "#{self.subdomain_was}.#{self.default_domain_was}"
    end
end