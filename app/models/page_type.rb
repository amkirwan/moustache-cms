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
    @page_types.find { |page_type| page_type.id == id.to_s.downcase }.dup
  end
  
  def self.find_by_name(name)
    @page_types.find { |page_types| page_types.name == name.to_s.downcase }.dup
  end
  
  @page_types = [
    PageType.new(:name => "normal"),
    PageType.new(:name => "container"),
    PageType.new(:name => "post")
  ]

end