class Filter
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :page
  
  def self.all
    @filters.dup
  end
  
  @filters = [
    Filter.new(:id => 1, :name => "markdown"),
    Filter.new(:id => 2, :name => "textile"),
    Filter.new(:id => 3, :name => "html"),
    Filter.new(:id => 4, :name => "haml")
  ]
end