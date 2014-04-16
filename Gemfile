source 'http://rubygems.org'

gem "rails", "3.2.17"   

group :assets do
  gem "sass-rails", "~> 3.2.6"
  gem "uglifier", ">= 2.5.0"
end
gem "coffee-rails", "~> 3.2.1"

gem "jquery-rails"
gem "haml-rails", "~> 0.4"

# mongoid
gem "mongoid", "~> 3.0"
gem "mongoid-tree", :git => "git://github.com/benedikt/mongoid-tree"
gem "mongoid-simple-tags", :git => "git://github.com/chebyte/mongoid-simple-tags.git"
gem "carrierwave-mongoid", :git => "git://github.com/jnicklas/carrierwave-mongoid.git", :branch =>  "mongoid-3.0"

# authorization
gem "devise", "~> 2.0"
gem "cancan", ">= 1.6" # must come after mongoid in Gemfile

gem "mustache", ">= 0.99"
gem "RedCloth", "~> 4.2"
gem "redcarpet", "~> 2.0"
gem "mime-types"
gem "kaminari"
# gem "rakismet" #uncomment to spam filter comments on articles

gem "nokogiri", "~> 1.5"
gem "unicorn"

# gem "capistrano" #uncomment to capify

group :development, :test do
  gem "rspec-rails", "~> 2.9"
  gem "cucumber-rails", "~> 1.3", :require => false
  gem "capybara"
  gem "selenium-webdriver", "~> 2.34.0"
  gem "launchy"
  gem "database_cleaner"
  gem "factory_girl_rails", "~> 3.1"
  gem "mongoid-rspec"
  gem "hpricot"
  gem "syntax"   
  gem "relish"
  gem "guard"
  gem 'rb-fsevent', '~> 0.9.1'
  gem "guard-cucumber", :git => "git://github.com/netzpirat/guard-cucumber.git"
  gem "guard-rspec"
  gem "guard-spork"
  gem "guard-pow"
end
