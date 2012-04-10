module HandlebarCms
  module CalcMd5
    extend ActiveSupport::Concern

    included do
      field :filename_md5
      field :file_path_md5
      field :file_path_md5_old
      field :url_md5

      before_save :calc_md5
      before_update :move_file_md5
      before_destroy :destroy_md5
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

    def destroy_md5
      if self.respond_to?(:file_path_md5)
        if File.exists?(self.file_path_md5)
          File.delete(self.file_path_md5)
        end
      end
    end

  end
end


