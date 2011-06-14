class PagePart
  include Mongoid::Document 
  
  # -- Fields -------
  field :name
  key :name
  field :content
  
  # -- Associations ---------
  embedded_in :page, :inverse_of => :page_parts
  embeds_one :filter, :as => :filterable
  
  accepts_nested_attributes_for :filter
  
  # -- Validations ------------
  validates :name,
            :presence => true,
            :uniqueness => true
  
  validates :filter,
            :presence => true
            
  # -- Class Methods ----------          
  def self.find_by_name(name)
    self.where(:name => name.to_s).first
  end
end