class TextFilter
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  embedded_in :layout, :inverse_of => :text_filter
end