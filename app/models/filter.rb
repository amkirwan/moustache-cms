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
    filter = @filters.find { |filter| filter.id == id.to_s.downcase }
    filter.dup unless filter.nil?
  end
  
  def self.find_by_name(name)
    filter = @filters.find { |filter| filter.name == name.to_s.downcase }
    filter.dup unless filter.nil?
  end
  
  @filters = [
    Filter.new(:name => "liquid"),
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "html")
  ]
end