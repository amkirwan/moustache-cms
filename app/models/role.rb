class Role
  include Mongoid::Document
  field :type, :type => String
  field :description, :type => String
end
