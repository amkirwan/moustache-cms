class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
   
  attr_accessible :firstname, :lastname, :email 
  
  # -- Fields -----------------------------------------------    
  field :puid
  index :puid         
  field :firstname
  field :lastname
  field :email
  field :role 
  
  #-- Associations-----------------------------------------------
  has_many :layouts_created, :class_name => "Layout", :foreign_key => :created_by_id
  has_many :layouts_updated, :class_name => "Layout", :foreign_key => :updated_by_id

  has_many :pages_created, :class_name => "Page", :foreign_key => :created_by_id
  has_many :pages_updated, :class_name => "Page", :foreign_key => :updated_by_id
  has_and_belongs_to_many :pages, :class_name => "Page"

  has_many :snippets_created, :class_name => "Snippet", :foreign_key => :created_by_id
  has_many :snippets_updated, :class_name => "Snippet", :foreign_key => :updated_by_id

  has_many :theme_assets_created, :class_name => "ThemeAsset", :foreign_key => :created_by_id
  has_many :theme_assets_updated, :class_name => "ThemeAsset", :foreign_key => :updated_by_id

  belongs_to :site

  # -- Before Validations -----------------------------------------------
  before_validation :uniq_page_ids
  before_save :lower, :set_puid
                       
  Roles = %w[editor designer admin] unless defined?(Roles)
  
  # -- Validations -----------------------------------------------
  validates :puid,
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


  # -- Class Methods -----------------------------------------------
  def self.find_by_puid(name)
    User.where(:puid => name.to_s).first
  end

  # -- Instance Methods -----------------------------------------------
  def role?(base_role)
    role.nil? ? false : Roles.index(base_role.to_s) <= Roles.index(role)
  end

  def full_name
    "#{firstname.capitalize} #{lastname.capitalize}"
  end
  
  private
  
    def tester?
      true
    end
    
    def uniq_page_ids
      self.page_ids.uniq!
    end
  
    def lower
      self.puid.downcase!
      self.email.downcase!
    end
  
    def set_puid
      self.puid = self.puid
    end
end
