class User
  include Mongoid::Document
  include Mongoid::Timestamps

  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :timeoutable
   
  attr_accessible :firstname,
                  :middlename,
                  :lastname,
                  :email,
                  :password,
                  :password_confirmation, 
                  :remember_me
  
  # -- Fields -----------------------------------------------    
  field :username
  field :firstname
  field :middlename
  field :lastname
  field :role 

  # -- Devise Authenticatable -----
  field :email, :null => false
  field :encrypted_password, :null => false

  # -- Devise Recoverable ---
  field :reset_password_token
  field :reset_password_sent_at, :type => Time

  # -- Devise Rememberable ---
  field :remember_created_at, :type => Time

  # -- Devise Trackable ---
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip
  field :last_sign_in_ip


  # -- Index -------------------------------
  index :username
  
  #-- Associations-----------------------------------------------
  has_many :layouts_created, :class_name => "Layout", :foreign_key => :created_by_id
  has_many :layouts_updated, :class_name => "Layout", :foreign_key => :updated_by_id

  has_many :pages_created, :class_name => "Page", :foreign_key => :created_by_id
  has_many :pages_updated, :class_name => "Page", :foreign_key => :updated_by_id

  has_many :snippets_created, :class_name => "Snippet", :foreign_key => :created_by_id
  has_many :snippets_updated, :class_name => "Snippet", :foreign_key => :updated_by_id

  has_many :asset_collections_created, :class_name => "AssetCollection", :foreign_key => :created_by_id
  has_many :asset_collections_updated, :class_name => "AssetCollection", :foreign_key => :updated_by_id

  has_many :theme_collections_created, :class_name => "ThemeCollection", :foreign_key => :created_by_id
  has_many :theme_collections_updated, :class_name => "ThemeCollection", :foreign_key => :updated_by_id

  has_many :article_collections_created, :class_name => "ArticleCollection", :foreign_key => :created_by_id
  has_many :article_collections_updated, :class_name => "ArticleCollection", :foreign_key => :updated_by_id

  has_many :authors_created, :class_name => "Author", :foreign_key => :created_by_id
  has_many :authors_updated, :class_name => "Author", :foreign_key => :updated_by_id

  has_many :articles_created, :class_name => "Article", :foreign_key => :created_by_id
  has_many :articles_updated, :class_name => "Article", :foreign_key => :updated_by_id

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
    if middlename.nil? || middlename.blank?
      "#{firstname.capitalize} #{lastname.capitalize}"
    else
      "#{firstname.capitalize} #{middlename.slice(0).capitalize} #{lastname.capitalize}"
    end
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

  def clone_and_add_to_site(site)
    new_user = self.clone
    new_user.password = self.password
    new_user.site_id = site.id
    new_user.save
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
