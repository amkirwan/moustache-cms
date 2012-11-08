class MoustacheCms::CustomField 
  include Mongoid::Document 
   
  # -- Fields ---
  field :name
  field :content

  # -- Association --
  embedded_in :custom_fieldable, :polymorphic => true

  validates :name,
            :presence => true,
            :uniqueness => true

end

