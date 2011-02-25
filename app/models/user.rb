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
