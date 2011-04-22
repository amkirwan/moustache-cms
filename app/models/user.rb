class User
  include Mongoid::Document
  include Mongoid::Timestamps
   
  attr_accessible :firstname, :lastname, :email 
  
  # -- Fields -----------------------------------------------    
  field :puid
  index :puid, unique: true
  key :puid         
  field :username
  index :username, unique: true
  field :firstname
  field :lastname
  field :email
  field :role 
  
  #-- Associations-----------------------------------------------
  references_many :layouts_created, :class_name => "Layout", :foreign_key => :created_by_id
  references_many :layouts_updated, :class_name => "Layout", :foreign_key => :updated_by_id
  references_many :pages_created, :class_name => "Page", :foreign_key => :created_by_id
  references_many :pages_updated, :class_name => "Page", :foreign_key => :updated_by_id
  references_and_referenced_in_many :pages, :class_name => "Page"
  
  # -- Validations -----------------------------------------------
  before_validation :uniq_page_ids
  before_save :lower, :set_username
                       
  Roles = %w[editor admin] unless defined?(Roles)
  
  validates :puid,
            :presence => true,
            :uniqueness => true,
            :length => { :minimum => 3 }
  
  validates :role, :presence => true
  
  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i }

  # -- Class Methods -----------------------------------------------
  def self.find_by_username(name)
    User.where(:username => name.to_s).first
  end

  # -- Instance Methods -----------------------------------------------
  def role?(base_role)
    Roles.index(base_role.to_s) <= Roles.index(role)
  end
  
  private
    def uniq_page_ids
      self.page_ids.uniq!
    end
  
    def lower
      self.puid.downcase!
      self.email.downcase!
    end
  
    def set_username
      self.username = self.puid
    end
end
