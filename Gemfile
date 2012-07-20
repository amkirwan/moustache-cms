source 'http://rubygems.org'

gem "rails", "3.2.6"   

group :assets do
  gem "sass-rails", "~> 3.2.3"
  gem "uglifier", ">= 1.0.3"
end
gem "coffee-rails", "~> 3.2.1"

gem "jquery-rails"
gem "haml-rails", "~> 0.3"

# mongoid
gem "mongoid", "~> 2.4"
gem "bson_ext", "~> 1.5"    
gem "mongoid-tree", :git => "git://github.com/benedikt/mongoid-tree", :tag=> 'v0.7.0', :require => "mongoid/tree"
gem "mongoid_taggable_with_context", :git => "git://github.com/amkirwan/mongoid_taggable_with_context.git", :branch => "master"
#gem "carrierwave-mongoid", :require => "carrierwave/mongoid"
gem "carrierwave-mongoid", :git => "git://github.com/jnicklas/carrierwave-mongoid.git", :branch => "carrierwave-0.6-support"

# authorization
gem "devise", "~> 2.0"
gem "cancan", ">= 1.6" # must come after mongoid in Gemfile

gem "mustache", ">= 0.99"
gem "RedCloth", "~> 4.2"
gem "redcarpet", "~> 2.0"
gem "mime-types"
gem "kaminari"

gem "unicorn"

group :development, :test do
  gem "rspec-rails", "~> 2.9"
  gem "cucumber-rails", "~> 1.3", :require => false
  gem "capybara"
  gem "launchy"
  gem "database_cleaner"
  gem "factory_girl_rails", "~> 3.1"
  gem "mongoid-rspec"
  gem "hpricot"
  gem "syntax"   
  gem "relish"
  gem "guard"
  gem "guard-cucumber", :git => "git://github.com/netzpirat/guard-cucumber.git"
  gem "guard-rspec"
  gem "guard-spork"
  gem "guard-pow"
end
