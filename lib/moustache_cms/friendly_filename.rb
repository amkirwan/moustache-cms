module MoustacheCms
  module FriendlyFilename
    extend ActiveSupport::Concern

    included do
      if self.respond_to?(:model_name)
        field :filename, :default => ''

        before_save :friendly_filename
      end
    end

    def friendly_filename
        self.filename = self.name.gsub(/[^\w\s_-]+/, '')
                                .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
                                .gsub(/\s+/, '_')
    end


  end
end

