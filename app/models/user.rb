class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, 
         :trackable, :lockable, :timeoutable
         
  field :username
  field :firstname
  field :lastname 
  field :role 
  embeds_many :email_addresses 
                       
  Roles = %w[admin editor]
  
  validates_presence_of :username, :role, :email
  validates_uniqueness_of :username, :email 
end
