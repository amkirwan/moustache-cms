class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
         
  field :username
  index :username, :unique => true
  field :email
  field :role 
                       
  Roles = %w[admin editor]
  
  validates_presence_of :username, :role, :email
  validates_uniqueness_of :username, :email 
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
end
