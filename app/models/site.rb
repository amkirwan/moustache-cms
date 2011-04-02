class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_accessible :name, :hostname
  
  field :name
  key :name
  field :hostname
  
  # -- Associations ---------------------------------------
  references_many :pages 
  
  # -- Validations ----------------------------------------
  validates :name,
            :presence => true,
            :uniqueness => true
  validates :hostname,
            :presence => true,
            :uniqueness => true
  
  # -- Class Methods ---------------------------------------
  def self.find_by_hostname(hostname)
    self.where(:hostname => hostname).first
  end
  
end