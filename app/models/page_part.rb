class PagePart
  include Mongoid::Document 
  
  field :name
  key :name
  field :content
  field :filter, :type => Filter
  
  embedded_in :page, :inverse_of => :page_parts
  
  validates :name,
            :presence => true,
            :uniqueness => true
  validates :filter,
            :presence => true
            
  def self.find_by_name(name)
    self.where(:name => name).first
  end
end