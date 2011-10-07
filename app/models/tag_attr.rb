class TagAttr
  include Mongoid::Document

  # -- Fields ---
  field :name
  field :content

  # -- Association ---
  embedded_in :tag_attrable, :polymorphic => true

end
