module MoustacheCms
  module DefaultMetaTags
    extend ActiveSupport::Concern

    included do
      attr_accessible :meta_tags_attributes

      embeds_many :meta_tags, :as => :meta_taggable
      accepts_nested_attributes_for :meta_tags

      after_initialize :default_meta_tags
    end

    def default_meta_tags
      if self.new_record? && self.meta_tags.size == 0
        self.meta_tags.build(:name => "title", :content => "")
        self.meta_tags.build(:name => "keywords", :content => "")
        self.meta_tags.build(:name => "description", :content => "")
      end
    end

  end
end
