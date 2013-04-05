class MetaTag
  include Mongoid::Document 
   
  # -- Fields ---
  field :name
  field :content

  # -- Association --
  embedded_in :meta_taggable, :polymorphic => true

  validates :name,
            :presence => true,
            :uniqueness => true

  before_save :format_name
 
  def format_name
    self.name.gsub!(/-/, '_')  
  end

end
