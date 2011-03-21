class Filter
  include Mongoid::Document 
  
  class << self
    attr_accessor :filters
  end
  
  field :name
  key :name
  
  validates :name,
            :presence => true
  
  def self.all
    @filters.dup
  end
  
  def self.find(id)
    @filters.find { |filter| filter.id == id.to_s.downcase }.dup
  end
  
  def self.find_by_name(name)
    @filters.find { |filter| filter.name == name.to_s.downcase }.dup
  end
  
  @filters = [
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "html"),
    Filter.new(:name => "haml")
  ]
end