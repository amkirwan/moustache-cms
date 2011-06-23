class PagePart
  include Mongoid::Document 
  
  # -- Fields -------
  field :name
  key :name
  field :content                               
  field :filter_name
  
  # -- Associations ---------
  embedded_in :page, :inverse_of => :page_parts
  
  accepts_nested_attributes_for :filter
  
  # -- Validations ------------
  validates :name,
            :presence => true,
            :uniqueness => true
  
  validates :filter_name,
            :presence => true
            
  # -- Class Methods ----------          
  def self.find_by_name(name)
    self.where(:name => name.to_s).first
  end
end