class PageType
  include Mongoid::Document 
  
  class << self
    attr_accessor :page_types
  end
  
  field :name
  key :name
  
  validates :name,
            :presence => true
            
  def self.all
    @page_types.dup
  end
  
  def self.find(id)
    type = @page_types.find { |page_type| page_type.id == id.to_s.downcase }
    type unless type.nil?
  end
  
  def self.find_by_name(name)
    type = @page_types.find { |page_types| page_types.name == name.to_s.downcase }
    type unless type.nil?
  end
  
  @page_types = [
    PageType.new(:name => "normal"),
    PageType.new(:name => "container"),
    PageType.new(:name => "post")
  ]

end