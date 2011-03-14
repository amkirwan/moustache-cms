class User
  include Mongoid::Document
  include Mongoid::Timestamps
   
  attr_accessible :username, :email 
       
  field :puid
  index :puid, :unique => true
  key :puid         
  field :username
  field :email
  field :role 
  
  references_many :layouts_created, :class_name => "Layout", :inverse_of => :created_by
  references_many :layouts_updated, :class_name => "Layout", :inverse_of => :updated_by
  references_many :pages_created, :class_name => "Page", :inverse_of => :created_by
  references_many :pages_updated, :class_name => "Page", :inverse_of => :updated_by
                       
  Roles = %w[editor admin]
  
  validates :puid,
            :presence => true,
            :uniqueness => true,
            :length => { :minimum => 3 }
            
  validates :username,
            :presence => true,
            :uniqueness => true,
            :length => { :minimum => 3, :maximum => 20 }
  
  validates :role, :presence => true
  
  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i }

  def role?(base_role)
    Roles.index(base_role.to_s) <= Roles.index(role)
  end
end
