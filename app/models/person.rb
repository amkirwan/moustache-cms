class Person
  include Mongoid::Document 
  include Mongoid::Timestamps
  field :username, :type => String 
  field :email, :type => String    
  field :passord, :type => String
  embeds_many :roles
  
  validates_presence_of :username, :email
end
