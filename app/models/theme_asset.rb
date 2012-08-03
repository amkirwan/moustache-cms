class ThemeAsset 
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::CalcMd5

  attr_accessible :name, 
                  :description, 
                  :content_type,
                  :width,
                  :height,
                  :file_size,
                  :asset,
                  :theme_asset_attributes,
                  :custom_fields_attributes

  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer 
  field :creator_id
  field :updator_id

  mount_uploader :asset, ThemeAssetUploader

  # -- Associations ----------
  embedded_in :article_collection  
  embeds_many :custom_fields, :as => :custom_fieldable
  accepts_nested_attributes_for :custom_fields

  # -- Validations --------------
  validates :name, :presence => true 
  validates :asset, :presence => true
  
  # -- Callbacks
  before_validation :set_name
  before_save :update_asset_attributes
  before_update :recreate

  set_asset_folder :theme_assets

  def set_name
    unless self.name.nil?
      if self.name.strip.empty?
        name_split = self.asset.file.filename.split('.')
        self.name = name_split.slice(0, name_split.length - 1).join('.')
      end
    end
  end

  def recreate
    self.asset.recreate_versions!
  end
  
  def update_asset_attributes         
    self.content_type = asset.file.content_type unless asset.file.content_type.nil?
    self.file_size = asset.file.size 
  end

    # -- Class Methods --------
  scope :css_files, lambda { { :where => { :content_type => "text/css" }} }
  scope :js_files, lambda { { :where => { :content_type => /.*javascript$/i } }}
  scope :javascripts, lambda { { :where => { :content_type => /.*javascript$/i } }}
  scope :images, lambda { { :where => { :content_type => /^image\/*/i }} }
  scope :other_files, lambda { { :where => { :content_type => {"$nin" => ['text/css', 'application/javascript', 'application/x-javascript', 'text/javascript', 'image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'image/vnd.microsoft.icon'] } } }}

  scope :find_by_name, lambda { |name| { :where => { :name => name }} }

  def self.find_by_content_type_and_site_id(opts={})
    [:content_type, :site].inject(scoped) do |combined_scope, attr| 
      combined_scope.where(attr => opts[attr])
    end
  end

  # -- Instance Methods ----------
  %w{image stylesheet javascript}.each do |type|
    define_method("#{type}?") do
      self.asset.send("#{type}?", self.asset.file)
    end
  end

  def css_file_by_name(name)
    self.css_files.where(:name => name).first
  end
  
  def update_file_content(file_contents)
    if self.content_type == "text/css" || self.content_type == "application/javascript" || self.content_type == 'application/x-javascript' || self.content_type == 'text/javascript'
      File.open(self.asset.path, "w") { |f| f.write(file_contents) }
      File.open(self.current_path_md5, 'w') { |f| f.write(file_contents) }
    elsif !File.exists?(self.current_path_md5)
      logger.debug "old=#{self.current_path_md5} " * 5
      File.rename(File.join(Rails.root, 'public', self.store_dir_md5, self.filename_md5_was), self.current_path_md5)
    else 
     true
    end 
  end

end
