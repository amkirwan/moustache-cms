class CurrentState
  include Mongoid::Document 
  
  class << self
    attr_accessor :statuses
  end
  
  field :name
  key :name
  field :time, :type => DateTime
  embedded_in :page, :inverse_of => :current_state
  
  validates :name,
            :presence => true
            
            
  #-- Class Methods --------------------------------------------------
  def self.all
    @statuses.dup
  end
  
  def self.find(id)
    status = @statuses.find { |status| status.id == id.to_s.downcase }
    if status.nil?
      status
    else
      status_dup = status.dup
      status_dup.time = DateTime.now
      status_dup
    end
  end
    
  def self.find_by_name(name)
    status = @statuses.find { |status| status.name == name.to_s.downcase }
    if status.nil?
      status
    else
      status_dup = status.dup
      status_dup.time = DateTime.now
      status_dup
    end
  end
  
  #-- Instance Methods --------------------------------------------------
  def published?
    if self.name == "published"
      return true
    else
      return false
    end 
  end
  
  def published_at
    if published?
      return self.time
    else
      return nil
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
    CurrentState.new(:name => "published", :time => nil),
    CurrentState.new(:name => "draft", :time => nil)
  ]
end