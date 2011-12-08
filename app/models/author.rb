class Author
  include Mongoid::Document 
  include Mongoid::Timestamps

  attr_accessible :prefix,
                  :firstname,
                  :middlename,
                  :lastname,
                  :profile

  # -- Fields ------
  field :prefix
  field :firstname
  field :middlename
  field :lastname
  field :profile

  # -- Associations ---
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"


  # -- Callbacks ---
  before_save :strip_whitespace

  def full_name
    if self.middlename.nil?
      self.firstname.capitalize + ' ' + self.lastname.capitalize
    else
      self.firstname.capitalize + ' ' + self.middlename.capitalize + ' ' + self.lastname.capitalize
    end
  end

  private 
    def strip_whitespace
      self.firstname.strip!
      self.middlename.strip!
      self.lastname.strip!
    end
end
