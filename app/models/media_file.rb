class MediaFile
  include Mongoid::Document
  field :name, :type => String
  field :description, :type => String
  field :alt_text, :type => String
  field :caption, :type => String
  field :local_path, :type => String
  field :content_type, :type => String
end
