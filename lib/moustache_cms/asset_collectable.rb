module MoustacheCms
  module AssetCollectable
    extend ActiveSupport::Concern

    include MoustacheCms::Collectable
    include MoustacheCms::CreatedUpdatedBy

  end
end
