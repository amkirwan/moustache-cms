class ArticleCollection

  include Mongoid::Document
  include Mongoid::Timestamps


    # -- Fields --------------- 
  field :name
  
  # -- Associations -------------
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  embeds_many :articles

  # -- Validations -------
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }

end
