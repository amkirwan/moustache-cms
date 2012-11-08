module MoustacheCms
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path("#{self.root}/lib", __FILE__)

    isolate_namespace MoustacheCms
  end
end
