class ThemeAsset 
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :name, 
                  :description, 
                  :content_type,
                  :width,
                  :height,
                  :file_size,
                  :asset,
                  :theme_asset_attributes,
                  :tag_attrs_attributes
  
  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer 
  field :creator_id
  field :updator_id
  field :filename_md5
  field :file_path_md5
  field :file_path_md5_old
  field :url_md5
  mount_uploader :asset, ThemeAssetUploader
   
  # -- Associations ----------
  embedded_in :article_collection  
  embeds_many :tag_attrs, :as => :tag_attrable

  accepts_nested_attributes_for :tag_attrs

  # -- Validations --------------
  validates :name, :presence => true 
  validates :asset, :presence => true
  
  # -- Callbacks
  before_save :update_asset_attributes, :calc_md5
  before_update :recreate
  before_destroy :destroy_md5

    
  def recreate
    self.asset.recreate_versions!
  end
  
  def update_asset_attributes         
    self.content_type = asset.file.content_type unless asset.file.content_type.nil?
    self.file_size = asset.file.size 
  end

  def calc_md5
    if self.new_record?
      chunk = self.asset.read
      md5 = ::Digest::MD5.hexdigest(chunk)
      self.filename_md5 = "#{self.name.split('.').first}-#{md5}.#{self.asset.file.extension}"
      self.file_path_md5 = File.join(Rails.root, 'public', self.asset.store_dir, '/', self.filename_md5)
      self.url_md5 = "/#{self.asset.store_dir}/#{self.filename_md5}"
      FileUtils.mkdir_p File.join(Rails.root, 'public', self.asset.store_dir)
      File.open(self.file_path_md5, 'wb') { |f| f.write(chunk) }
    end
  end
  
  # -- Class Methods --------
  scope :css_files, lambda { { :where => { :content_type => "text/css" }} }
  scope :js_files, lambda { { :where => { :content_type => "application/x-javascript" }} }
  scope :images, lambda { { :where => { :content_type => /^image/i }} }
  scope :find_by_name, lambda { |name| { :where => { :name => name }} }


  def self.find_by_content_type_and_site_id(opts={})
    [:content_type, :site].inject(scoped) do |combined_scope, attr| 
      combined_scope.where(attr => opts[attr])
    end
  end


  def self.other_files(site)
    ThemeCollection.criteria.for_ids(site.id).where("theme_assets.content_type" => {"$nin" => ['text/css', 'text/javascript', /^image/i]}).asc(:name).to_a
  end
  
  # -- Instance Methods ----------
  %w{image stylesheet javascript}.each do |type|
    define_method("#{type}?") do
      self.asset.send("#{type}?", self.asset.file)
    end
  end

  
  def update_file_content(file_contents)
    if self.content_type == "text/css" || self.content_type == "application/x-javascript"
      File.open(self.asset.path, "w") { |f| f.write(file_contents) }
      File.delete(self.file_path_md5_old) if (!self.file_path_md5_old.nil? && File.exists?(self.file_path_md5_old))
      File.open(self.file_path_md5, 'wb') { |f| f.write(file_contents) }
    elsif !File.exists?(self.file_path_md5)
        File.rename(self.file_path_md5_old, self.file_path_md5)
    else 
     true
    end 
  end

  def destroy_md5
    if self.respond_to?(:file_path_md5)
      if File.exists?(self.file_path_md5)
        File.delete(self.file_path_md5)
      end
    end
  end

end



