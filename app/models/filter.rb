class Filter
  include Mongoid::Document 
  
  class << self
    attr_reader :filters, :filters_admin
  end
  
  # -- Fields -------
  field :name
  key :name
  
  # -- Associations -------
  embedded_in :filterable, :polymorphic => true
  
  # -- Validates -------
  validates :name,
            :presence => true
  
  # -- ClassMethods
  def self.all
    @filters
  end
  
  def self.all_page_filters
    @filters_page
  end
  
  def self.find(id)
    filter = @filters.find { |filter| filter.id == id.to_s.downcase }
    filter unless filter.nil?
  end
  
  def self.find_by_name(name)
    name = name.to_s
    filter = @filters.find { |filter| filter.name == name.to_s.downcase }
    filter unless filter.nil?
  end
  
  @filters = [
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "haml"),
    Filter.new(:name => "html")
  ]
  
  @filters_page = [
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "html")
    ]
end
