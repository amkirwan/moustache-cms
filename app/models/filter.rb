class Filter
  include Mongoid::Document 
  
  class << self
    attr_accessor :filters
  end
  
  # -- Fields -------
  field :name
  key :name
  
  # -- Associations -------
  embedded_in :filterable, polymorphic: true
  
  # -- Validates -------
  validates :name,
            :presence => true
  
  # -- ClassMethods
  def self.all
    @filters.dup
  end
  
  def self.find(id)
    filter = @filters.find { |filter| filter.id == id.to_s.downcase }
    filter.dup unless filter.nil?
  end
  
  def self.find_by_name(name)
    name = name.to_s
    filter = @filters.find { |filter| filter.name == name.to_s.downcase }
    filter.dup unless filter.nil?
  end
  
  @filters = [
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "html")
  ]
end