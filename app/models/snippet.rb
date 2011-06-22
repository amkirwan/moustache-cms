class Snippet
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_accessible :name, :content, :filter_name
  # -- Fields ----
  field :name
  field :content
  field :filter_name
                   
  #-- Assocations ----
  belongs_to :site 

  accepts_nested_attributes_for :filter
end