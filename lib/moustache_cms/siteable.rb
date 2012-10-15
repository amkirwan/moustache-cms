module MoustacheCms
  module Siteable
    extend ActiveSupport::Concern

    included do
      belongs_to :site

      validates :site_id,
                :presence => true
    end
  end
end
