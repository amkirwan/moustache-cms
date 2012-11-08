class MoustacheCms::User
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::Siteable
  include MoustacheCms::Deviseable
  
   
  attr_accessible :firstname,
                  :middlename,
                  :lastname,
                  :email,
                  :password,
                  :password_confirmation, 
                  :remember_me,
                  :time_zone
  
  # -- Fields -----------------------------------------------    
  field :username
  field :firstname
  field :middlename
  field :lastname
  field :role 
  field :time_zone

  # -- Index -------------------------------
  index :username => 1
  
  #-- Associations-----------------------------------------------
  %w(Layout Page Snippet AssetCollection ThemeCollection ArticleCollection Author Article).each do |name|
    created = name.underscore.pluralize + '_created'
    updated = name.underscore.pluralize + '_updated'
    has_many created.to_sym, class_name: name, inverse_of: :created_by
    has_many updated.to_sym, class_name: name, inverse_of: :updated_by
  end
  
  has_and_belongs_to_many :pages, :class_name => "Page", :inverse_of => :editors
  has_and_belongs_to_many :article_collections, :class_name => "ArticleCollection", :inverse_of => :editors

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
  
  validates :time_zone,
            :presence => true

  # -- Scopes ---------
  scope :all_from_current_site, ->(current_site) { where(:site_id => current_site.id) } 

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

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    result = check_if_passwords_are_blank(params)
    result = check_if_passwords_are_equal(params) unless result == false
    result = check_if_password_is_valid(params, current_password, result)  unless result == false
    clean_up_passwords 
    result
  end
  def clone_and_add_to_site(site)
      new_user = self.clone
    new_user.password = self.password
    new_user.site_id = site.id
    new_user.save
  end

  def lower
    self.username.downcase!
    self.email.downcase!
  end

  private 

  def uniq_page_ids
    self.page_ids.uniq!
  end

  def set_username
    self.username = self.username
  end

  def check_if_password_is_valid(params, current_password, result)
    if valid_password?(current_password) 
      update_attributes(params) 
    else
      set_password_update_error(params, :current_password, current_password.blank? ? :blank : :invalid)
    end
  end

  def check_if_passwords_are_equal(params)
    if params[:password] != params[:password_confirmation] 
      set_password_update_error(params, :password, 'does not match confirmation password')
      set_password_update_error(params, :password_confirmation, 'does not match password')
    end
  end

  def check_if_passwords_are_blank(params)
    result = if params[:password].blank? 
      set_password_update_error(params)
    end
    
    result = if params[:password_confirmation].blank?
      set_password_update_error(params, :password_confirmation)
    end
    result
  end

  def set_password_update_error(params, field=:password, msg=:blank)
    self.assign_attributes(params)
    self.errors.add(field.to_sym, msg)
    false
  end

end

