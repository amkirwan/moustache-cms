class Filter
  include Mongoid::Document 
  
  # -- Fields -------
  field :name
  field :_id, type: String, default: ->{ name }
  
  # -- Associations -------
  embedded_in :filterable, :polymorphic => true
  
  # -- Validates -------
  validates :name,
            :presence => true
  
  class << self
    attr_reader :page_filters, :article_filters, :all_filters
  end

  @page_filters = [
    Filter.new(:name => "html"),
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "javascript")
  ]
  
  @article_filters = [
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "html")
  ]  
  
  @all_filters = [
    Filter.new(:name => "html"),
    Filter.new(:name => "markdown"),
    Filter.new(:name => "textile"),
    Filter.new(:name => "haml"),
    Filter.new(:name => "javascript")
  ]

  def self.all
    @all_filters
  end

  # -- ClassMethods
  def self.find(id)
    filter = @all_filters.find { |filter| filter.id == id.to_s.downcase }
    filter unless filter.nil?
  end
  
  def self.find_by_name(name)
    name = name.to_s
    filter = @all_filters.find { |filter| filter.name == name.to_s.downcase }
    filter unless filter.nil?
  end

end
