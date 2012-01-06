class SiteAsset 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Mongoid::TaggableWithContext

  attr_accessible :name,
                  :description,
                  :content_type, 
                  :width, 
                  :height, 
                  :file_size, 
                  :asset, 
                  :tags
  
  # -- Fields 
  field :name
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
  mount_uploader :asset, SiteAssetUploader  

  taggable
  
  # -- Associations ------
  embedded_in :asset_collection  
  
  # -- Validations -----
  validates :name, :presence => true
            
  validates :asset, :presence => true
  
  # -- Callbacks
  before_validation :set_name
  before_save :update_asset_attributes, :calc_md5
  before_update :recreate, :move_file_md5
  after_destroy :remove_folder  
    
  # -- Instance Methods     
  def set_name
    if self.name.strip.empty?
      name_split = self.asset.file.filename.split('.')
      self.name = name_split.slice(0, name_split.length - 1).join('.')
    end
  end

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

  def move_file_md5
    if !File.exists?(self.file_path_md5)
      File.rename(self.file_path_md5_old, self.file_path_md5)
    end 
  end

            
  def image?
    self.asset.image?(self.asset.file)
  end

  def remove_folder
    FileUtils.rm_rf(File.join(Rails.root, 'public', asset.store_dir))
  end

end
