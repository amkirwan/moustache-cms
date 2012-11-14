class Author
  include Mongoid::Document 
  include Mongoid::Timestamps

  include MoustacheCms::CalcMd5

  attr_accessible :prefix,
                  :firstname,
                  :middlename,
                  :lastname,
                  :honorific_suffix,
                  :title,
                  :organization,
                  :image,
                  :image_cache,
                  :custom_fields_attributes,
                  :profile

  # -- Fields ------
  field :prefix
  field :firstname
  field :middlename
  field :lastname
  field :honorific_suffix
  field :title
  field :organization
  field :profile
  mount_uploader :image, AuthorUploader

  # -- Associations ---
  belongs_to :site
  belongs_to :created_by, :class_name => "User", :inverse_of => :authors_created
  belongs_to :updated_by, :class_name => "User", :inverse_of => :authors_updated
  has_and_belongs_to_many :articles
  embeds_many :custom_fields, :as => :custom_fieldable

  accepts_nested_attributes_for :custom_fields
  # -- Validations ----
  validates :firstname,
            :presence => true

  validates :lastname,
            :presence => true

  validates :site_id,
            :presence => true

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
