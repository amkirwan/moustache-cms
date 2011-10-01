class ElementAttr
  include Mongoid::Document

  attr_accessible :html_attr

  # -- Fields ---
  field :html_attr, :type => Hash

  # -- Associations
  embedded_in :theme_asset

end
