class MetaData
  include Mongoid::Document
  
  # -- Fields --------------------------------------------------
  field :tags, :type => Hash, default: {}
  
  # -- Callbacks -----------------------------------------------
  after_initialize :create_default_meta_keys
  

  private 
    def create_default_meta_keys
      self.tags = { :title => nil, :keywords => nil, :description => nil }
    end
end