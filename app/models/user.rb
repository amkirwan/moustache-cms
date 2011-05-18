class User
  include Mongoid::Document
  include Mongoid::Timestamps
   
  attr_accessible :firstname, :lastname, :email 
  
  # -- Fields -----------------------------------------------    
  field :puid
  index :puid, unique: true
  key :puid         
  field :puid
  index :puid, unique: true
  field :firstname
  field :lastname
  field :email
  field :role 
  
  #-- Associations-----------------------------------------------
  has_many :layouts_created, :class_name => "Layout", :foreign_key => :created_by_id
  has_many :layouts_updated, :class_name => "Layout", :foreign_key => :updated_by_id
  has_many :pages_created, :class_name => "Page", :foreign_key => :created_by_id
  has_many :pages_updated, :class_name => "Page", :foreign_key => :updated_by_id
  has_many :media_files
  has_and_belongs_to_many :pages, :class_name => "Page"
  belongs_to :site
  
  # -- Before Validations -----------------------------------------------
  before_validation :uniq_page_ids
  before_save :lower, :set_puid
  before_destroy :delete_from_pages
                       
  Roles = %w[editor admin] unless defined?(Roles)
  
  # -- Validations -----------------------------------------------
  validates :puid,
            :presence => true,
            :uniqueness => { :scope => :site_id },
            :length => { :minimum => 3 }
  
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
    
    def delete_from_pages
      pages = Page.criteria.for_ids(self.page_ids)
      pages.each do |page|
        page.editor_ids.delete(self.id)
        page.save
      end 
    end
end
