module MoustacheCms
  module FriendlyFilename
    extend ActiveSupport::Concern

    included do
      if self.respond_to?(:model_name)
        before_save :friendly_filename
      end
    end

    def friendly_filename(filename=nil)
      filename = self.name if filename.nil?
      filename = filename.gsub(/[^\w\s_-]+/, '')
                              .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
                              .gsub(/\s+/, '_')
      if self.respond_to?(:name=)
        self.name = filename
      else
        filename
      end
    end

  end
end

