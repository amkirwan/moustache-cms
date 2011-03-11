class PagePart
  include Mongoid::Document 
  include Mongoid::Timestamps
  
  field :name
  key :name
  embeds_one :filter
  #embedded_in :page, :inverse_of => :pages
end