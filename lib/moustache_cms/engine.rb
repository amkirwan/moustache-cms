require File.expand_path('../request_current_site.rb', __FILE__)
require File.expand_path('../siteable.rb', __FILE__)
require File.expand_path('../deviseable.rb', __FILE__)

module MoustacheCms
  class Engine < ::Rails::Engine
    #config.autoload_paths << File.expand_path("#{self.root}/lib", __FILE__)

    isolate_namespace MoustacheCms
  end
end
