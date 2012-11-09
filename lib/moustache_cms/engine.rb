require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"
require "ostruct"

require 'mongoid'
require 'mongoid/tree'
require 'mongoid-simple-tags'
require 'devise'
require 'cancan'
require 'mustache'
require 'redcloth'
require 'redcarpet'
require 'mime/types'
require 'kaminari'
require 'carrierwave/mongoid'

module MoustacheCms
  class Engine < ::Rails::Engine
    isolate_namespace MoustacheCms
    config.autoload_paths << "#{self.root}/lib"
    config.autoload_paths << "#{self.root}/app/moustache_cms/uploaders"
  end
end
