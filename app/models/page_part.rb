class PagePart
  include Mongoid::Document 
  
  field :name
  key :name
  field :content
  
  embedded_in :page, :inverse_of => :page_parts
  
  validates :name,
            :presence => true
end