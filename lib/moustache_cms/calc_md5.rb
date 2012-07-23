module MoustacheCms
  module CalcMd5
    extend ActiveSupport::Concern

    included do
      field :filename_md5, :default => ''
      field :file_path_md5, :default => ''
      field :file_path_md5_old, :default => ''
      field :url_md5, :default => ''

      before_save :calc_md5
      before_update :calc_md5 #:move_file_md5
      before_destroy :destroy_md5
    end

    def calc_md5
      if self.new_record?
        chunk = read_file
        md5 = ::Digest::MD5.hexdigest(chunk)
        self.filename_md5 = set_filename_md5(md5)
        self.file_path_md5 = set_file_path_md5 
        self.url_md5 = set_url_md5 
        make_dirs
        File.open(self.file_path_md5, 'wb') { |f| f.write(chunk) }
      end
    end

    def move_file_md5
      if !File.exists?(self.file_path_md5)
        File.rename(self.file_path_md5_old, self.file_path_md5)
      end 
    end

    def destroy_md5
      if self.respond_to?(:file_path_md5)
        if File.exists?(self.file_path_md5)
          File.delete(self.file_path_md5)
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
          "#{self.image.filename.split('.').first}-#{md5}.#{self.image.file.extension}"
        else
          "#{self.name.split('.').first}-#{md5}.#{self.asset.file.extension}"          
        end
      end

      def set_file_path_md5
        if self.class == Author
          File.join(Rails.root, 'public', self.image.store_dir, '/', self.filename_md5)
        else
          File.join(Rails.root, 'public', self.asset.store_dir, '/', self.filename_md5)
        end
      end

      def set_url_md5
        if self.class == Author
          "/#{self.image.store_dir}/#{self.filename_md5}"
        else
          "/#{self.asset.store_dir}/#{self.filename_md5}"
        end
      end

      def make_dirs
        if self.class == Author
          FileUtils.mkdir_p File.join(Rails.root, 'public', self.image.store_dir)
        else
          FileUtils.mkdir_p File.join(Rails.root, 'public', self.asset.store_dir)
        end
      end

  end
end


