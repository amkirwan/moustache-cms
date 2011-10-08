class TagAttr
  include Mongoid::Document

  # -- Fields ---
  field :name
  field :value

  # -- Association ---
  embedded_in :tag_attrable, :polymorphic => true

end
