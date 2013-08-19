class CurrentState
  include Mongoid::Document 
  
  # -- Fields --------------------------------------------------
  field :name
  field :_id, type: String, default: ->{ name }
  field :time, type: Time

  # -- Associations ---
  embedded_in :publishable, :polymorphic => true

  @states = %w(draft published)

  # -- Validations --------------------------------------------------
  validates :name,
            :presence => true,
            :inclusion => { :in => @states,
            :message => "%{value} is not a valid option for state" }
            
  before_save lambda { self.time = Time.zone.now if self.changed? }


  # -- Class Methods --------------------------------------------------

  # return CurrentState array of all the available states 
  class << self
    def states
      @states.collect { |state| self.send(state) }
    end
    alias_method :all, :states
  end

  # create class methods of the @state types
  @states.each do |state|
    singleton_class.send(:define_method, state) do 
      self.new(:name => state, :time => nil)
    end
  end

  # -- Instance Methods --------------------------------------------------
  @states.each do |state|
    define_method(state) { self.name = state; self.save }
  end

  def published?
    self.name == 'published'
  end
  
  def published_on
    published? ? self.time : nil
  end
  
  def draft?
    self.name == 'draft'
  end

end
