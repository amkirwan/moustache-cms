class CssJsAsset
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # -- Fields ---------------
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :size, :type => Integer
  field :theme_asset
  
  # -- Associations ------------------------------
  mount_uploader :theme_asset, ThemeAssetUploader
  
end