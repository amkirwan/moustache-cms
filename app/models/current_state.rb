class CurrentState
  include Mongoid::Document 
  
  field :name, :type => String
  key :name
  embedded_in :page, :inverse_of => :current_state
  
  def self.all
    @statuses.dup
  end
  
  def self.find(id)
    @statuses.find { |status| status.id == id.to_s.downcase }.dup
  end
  
  def self.find_by_name(name)
    @statuses.find { |status| status.name == name.to_s.downcase }.dup
  end
  
  @statuses = [
    CurrentState.new(:name => "published"),
    CurrentState.new(:name => "draft")
  ]
end