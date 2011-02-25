class User
  include Mongoid::Document
  include Mongoid::Timestamps
   
  attr_accessible :username, :email      
  field :puid
  index :puid, :unique => true         
  field :username
  field :email
  field :role 
                       
  Roles = %w[editor admin]
  
  validates_presence_of :puid, :username, :role, :email
  validates_uniqueness_of :puid, :username, :email 
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
  validates_length_of :puid, :minimum => 3
  validates_length_of :username, :minimum => 3, :maximum => 20
  
  def role?(base_role)
    Roles.index(base_role.to_s) <= Roles.index(role)
  end
end
