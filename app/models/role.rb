class Role
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  embedded_in :person, :inverse_of => :roles
  
  validates_presence_of :name, :description
end                                     

