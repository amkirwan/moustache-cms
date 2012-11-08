$:.push File.expand_path("../lib", __FILE__)


require 'moustache_cms/version'

Gem::Specification.new do |s|
  s.name = "moustache_cms"
  s.version = MoustacheCms::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Forum."
  s.description = "TODO: Description of Forum."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.require_path = 'lib'
  s.test_files = Dir["test/**/*"]
  
  s.add_dependency "rails",             "~> 3.2.8"

  s.add_dependency "mongoid",           "~> 3.0"
  s.add_dependency "mongoid-tree",      "~> 1.0"
  s.add_dependency "mongoid-simple-tags"

  s.add_dependency "devise",            "~> 2.0"      
  s.add_dependency "cancan",            "~> 1.6"      

  s.add_dependency "mustache",          "~> 0.99"      
  s.add_dependency "RedCloth",          "~> 4.2"      
  s.add_dependency "redcarpet",          "~> 2.0"      
  s.add_dependency "mime-types"
  s.add_dependency "kaminari"
  s.add_dependency "carrierwave-mongoid"
end
