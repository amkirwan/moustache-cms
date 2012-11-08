class MoustacheCms::MetaTag
  include Mongoid::Document 
   
  # -- Fields ---
  field :name
  field :content

  # -- Association --
  embedded_in :meta_taggable, :polymorphic => true

  validates :name,
            :presence => true,
            :uniqueness => true

end
