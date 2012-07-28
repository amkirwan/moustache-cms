class Author
  include Mongoid::Document 
  include Mongoid::Timestamps

  include MoustacheCms::CalcMd5

  attr_accessible :prefix,
                  :firstname,
                  :middlename,
                  :lastname,
                  :image,
                  :profile

  # -- Fields ------
  field :prefix
  field :firstname
  field :middlename
  field :lastname
  field :profile
  mount_uploader :image, AuthorUploader

  # -- Associations ---
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  has_and_belongs_to_many :articles

  # -- Validations ----
  validates :firstname,
            :presence => true

  validates :lastname,
            :presence => true

  validates :image, :presence => true

  # -- Callbacks ---
  before_save :strip_whitespace

  set_asset_folder :authors

  def full_name
    if self.middlename.nil? || self.middlename.empty?
      self.firstname.capitalize + ' ' + self.lastname.capitalize
    else
      self.firstname.capitalize + ' ' + self.middlename.capitalize + ' ' + self.lastname.capitalize
    end
  end

  private 
    def strip_whitespace
      self.firstname.strip! unless self.firstname.nil?
      self.middlename.strip! unless self.middlename.nil?
      self.lastname.strip! unless self.lastname.nil?
    end
end
