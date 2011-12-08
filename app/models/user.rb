class User
  include Mongoid::Document
  include Mongoid::Timestamps

  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :timeoutable
   
  attr_accessible :firstname, :lastname, :email, :password, :password_confirmation, :remember_me
  
  # -- Fields -----------------------------------------------    
  field :username
  field :firstname
  field :lastname
  field :email
  field :role 

  # -- Index -------------------------------
  index :username
  
  #-- Associations-----------------------------------------------
  has_many :layouts_created, :class_name => "Layout", :foreign_key => :created_by_id
  has_many :layouts_updated, :class_name => "Layout", :foreign_key => :updated_by_id

  has_many :pages_created, :class_name => "Page", :foreign_key => :created_by_id
  has_many :pages_updated, :class_name => "Page", :foreign_key => :updated_by_id

  has_many :snippets_created, :class_name => "Snippet", :foreign_key => :created_by_id
  has_many :snippets_updated, :class_name => "Snippet", :foreign_key => :updated_by_id

  has_many :theme_assets_created, :class_name => "ThemeAsset", :foreign_key => :created_by_id
  has_many :theme_assets_updated, :class_name => "ThemeAsset", :foreign_key => :updated_by_id

  has_many :article_collections_created, :class_name => "ArticleCollection", :foreign_key => :created_by_id
  has_many :article_collections_updated, :class_name => "ArticleCollection", :foreign_key => :updated_by_id

  has_many :authors_created, :class_name => "Author", :foreign_key => :created_by_id
  has_many :authors_updated, :class_name => "Author", :foreign_key => :updated_by_id

  has_and_belongs_to_many :pages, :class_name => "Page", :inverse_of => :editors
  has_and_belongs_to_many :article_collections, :class_name => "ArticleCollection", :inverse_of => :editors

  belongs_to :site

  # -- Before Validations -----------------------------------------------
  before_validation :uniq_page_ids
  before_save :lower, :set_username
                       
  Roles = %w[editor designer admin superadmin] unless defined?(Roles)
  
  # -- Validations -----------------------------------------------
  validates :username,
            :presence => true,
            :uniqueness => { :scope => :site_id },
            :length => { :minimum => 3 }
  
  validates :firstname, :presence => true

  validates :lastname, :presence => true
  
  validates :role, :presence => true

  validates :email,
            :presence => true,
            :uniqueness => { :scope => :site_id },
            :format => { :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i }
  
  validates :site_id,
            :presence => true

  # -- Scopes ---------
  scope :all_from_current_site, lambda { |current_site| { :where => { :site_id => current_site.id }} }

  # -- Class Methods -----------------------------------------------
  def self.find_by_username(name)
    User.where(:username => name.to_s).first
  end

  # -- Instance Methods -----------------------------------------------
  def role?(base_role)
    role.nil? ? false : Roles.index(base_role.to_s) <= Roles.index(role)
  end

  def full_name
    "#{firstname.capitalize} #{lastname.capitalize}"
  end

  def update_with_password(params={})
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    if ((params[:password].blank? && params[:password_confirmation].blank?) || valid_password?(current_password))
      result = update_attributes(params)
    else
      self.attributes = params
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords if self.respond_to?(:password)
    result
  end
  
  private
  
    def tester?
      true
    end
    
    def uniq_page_ids
      self.page_ids.uniq!
    end
  
    def lower
      self.username.downcase!
      self.email.downcase!
    end
  
    def set_username
      self.username = self.username
    end
end
