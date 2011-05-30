class ThemeAsset
  include Mongoid::Document
  
  attr_accessible :name, :description, :content_type, :width, :height, :file_size, :source
  
  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer
  mount_uploader :source, ThemeAssetUploader
   
  # -- Associations ----------
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  
  # -- Callbacks
  before_save :update_asset_attributes
  before_update :recreate, :if => "self.name_changed?"
    
  def recreate
    self.source.recreate_versions!
    self.source_filename = "#{self.name}.#{self.source.file.extension}"
  end
  
  def update_asset_attributes         
    self.content_type = source.file.content_type unless source.file.content_type.nil?
    self.file_size = source.file.size 
  end
  
  # -- Class Methods --------
  scope :css_files, lambda { |site| { :where => { :content_type => "text/css", :site_id => site.id }} }
  scope :js_files, lambda { |site| { :where => { :content_type => "text/javascript", :site_id => site.id }} }
  scope :images, lambda { |site| { :where => { :content_type => /^image/i, :site_id => site.id }} }

  def self.find_by_content_type_and_site_id(opts={})
    [:content_type, :site].inject(scoped) do |combined_scope, attr| 
      combined_scope.where(attr => opts[attr])
    end
  end
end