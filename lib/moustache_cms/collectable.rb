module MoustacheCms
  module Collectable
    extend ActiveSupport::Concern

    def destroy_collection_folder(asset_folder)
      FileUtils.rm_rf(File.join(Rails.root, 'public', asset_folder, site.id.to_s, self.name))
    end

    module ClassMethods
      def collectable(collection)
        embeds_many collection.to_sym
        validates_associated collection.to_sym
      end
    end

  end
end
