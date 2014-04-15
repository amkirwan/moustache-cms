module MoustacheCms
  module CalcMd5
    extend ActiveSupport::Concern

    included do
      field :filename_md5, :default => ''

      before_create :calc_md5
      before_update :calc_md5
      before_destroy :destroy_md5
      
      attr_writer :asset_folder  
    end

    module ClassMethods
      def set_asset_folder(folder)
        define_method :asset_folder do 
          if @asset_folder
            @asset_folder
          else
            folder.to_s
          end
        end
      end
    end

    def calc_md5
      if self.new_record?
        chunk = read_file
        md5 = ::Digest::MD5.hexdigest(chunk)
        self.filename_md5 = set_filename_md5(md5)
        make_dirs
        File.open(self.current_path_md5, 'wb') { |f| f.write(chunk) }
      end
    end

    def store_dir_md5
      self.class == Author ? self.image.store_dir : self.asset.store_dir  
    end

    def store_path_md5
      if self.class == Author
        File.join(self.image.store_dir, self.filename_md5)
      else
        File.join(self.asset.store_dir, self.filename_md5)
      end
    end

    def destroy_md5
      if self.respond_to?(:current_path_md5)
        if File.exists?(self.current_path_md5)
          File.delete(self.current_path_md5)
        end
      end
    end

      def read_file
        if self.class == Author
          self.image.read
        else
          self.asset.read
        end
      end

      def set_filename_md5(md5)
        if self.class == Author
          split = self.image.filename.split('.')
          name_split = split[0, split.length - 1].join('.')
          "#{name_split}-#{md5}.#{self.image.file.extension}"
        else
          split = self.name.split('.')
          name_split = split[0, split.length - 1].join('.')
          "#{name_split}-#{md5}.#{self.asset.file.extension}"
        end
      end

      def current_path_md5
        if self.class == Author
          File.join(Rails.root, 'public', self.image.store_dir, '/', self.filename_md5)
        else
          File.join(Rails.root, 'public', self.asset.store_dir, '/', self.filename_md5)
        end
      end

      def asset_digest_path
        if self.class == Author
          File.join('/', "#{self.asset_folder}", self.site_id.to_s, "#{self.filename_md5}")
        elsif self.class == ThemeAsset
          theme_asset_url_md5
        else
          File.join('/', "#{self.asset_folder}", self._parent.site_id.to_s, self._parent.name, "#{self.filename_md5}")
        end
      end
      alias_method :url_md5, :asset_digest_path

      def make_dirs
        if self.class == Author
          FileUtils.mkdir_p File.join(Rails.root, 'public', self.image.store_dir)
        else
          FileUtils.mkdir_p File.join(Rails.root, 'public', self.asset.store_dir)
        end
      end

  end
end
