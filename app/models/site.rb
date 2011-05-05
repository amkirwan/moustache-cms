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
  has_many :pages 
  has_many :layouts
    
  # -- Validations ----------------------------------------
  validates :name,
            :presence => true,
            :uniqueness => true
  validates :subdomain,
            :presence => true,
            :uniqueness => true
            
  # -- Callbacks -----------------------------------------------
  before_save :add_subdomain_to_domains
  after_destroy :destroy_pages
            
  # -- Scopes ---------------------------------------
  scope :match_domain, lambda { |domain| { :any_in => { :domains => [*domain] }}}
  
 
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
  
  private
  
  def old_domain
    "#{self.subdomain_was}.#{self.default_domain_was}"
  end
  
  def destroy_pages
    self.pages.root.destroy
  end
end