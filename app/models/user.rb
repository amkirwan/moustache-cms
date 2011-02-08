class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
         
  field :username
  index :username, :unique => true
  field :email
  field :role 
                       
  Roles = %w[admin editor]
  
  validates_presence_of :username, :role, :email
  validates_uniqueness_of :username, :email 
end
