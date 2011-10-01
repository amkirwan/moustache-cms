class MetaTag
  include Mongoid::Document 
   
  # -- Fields ---
  field :tag, :type => Hash, :default => {}

  # -- Association --
  embedded_in :meta_taggable, :polymorphic => true

end
