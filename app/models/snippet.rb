class Snippet
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # -- Fields ----
  field :name
  field :content
                   
  #-- Assocations ----
  belongs_to :site 
  embeds_one :filter, :as => :filterable
  
  accepts_nested_attributes_for :filter
end