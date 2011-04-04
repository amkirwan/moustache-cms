class CurrentState
  include Mongoid::Document 
  
  class << self
    attr_accessor :statuses
  end
  
  field :name
  key :name
  field :published_at, :type => DateTime
  embedded_in :page, :inverse_of => :current_state
  
  validates :name,
            :presence => true
            
            
  #-- Class Methods --------------------------------------------------
  def self.all
    @statuses.dup
  end
  
  def self.find(id)
    status = @statuses.find { |status| status.id == id.to_s.downcase }
    status.dup unless status.nil?
  end
    
  def self.find_by_name(name)
    status = @statuses.find { |status| status.name == name.to_s.downcase }
    status.dup unless status.nil?
  end
  
  #-- Instance Methods --------------------------------------------------
  def published?
    if self.name == "published"
      return true
    else
      return false
    end 
  end
  
  def draft?
    if self.name == "draft"
      return true
    else
      return false
    end
  end
  
  @statuses = [
    CurrentState.new(:name => "published", :published_at => nil),
    CurrentState.new(:name => "draft", :published_at => nil)
  ]
end