require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f} 
  Dir[Rails.root.join("spec/spec_helpers/*.rb")].each {|f| require f}  

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures" 
    config.include(LoginHelpers)
    config.include(ControllerMacros, :type => :controller)
    config.include(Mongoid::Matchers)

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    #config.use_transactional_fixtures = true 
    require 'database_cleaner'
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end

    config.before(:each) do
      DatabaseCleaner.clean
    end 
    #ActiveSupport::Dependencies.clear
  end
end

Spork.each_run do
  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.





# This file is copied to spec/ when you run 'rails generate rspec:install'



module RSpec
  module Matchers
    class AllowMassAssignmentOf # :nodoc:
      def initialize hash = nil
        raise if hash.nil?
        raise unless hash.kind_of? Hash
        raise unless hash.length > 0
        @attributes = hash
      end

      def matches? model
        old = {}
        @attributes.each do |key, val|
          current = model.send(key.to_s)
          raise if val == current
          old[key] = current
        end
        model.update_attributes(@attributes)
        @attributes.keys.all? do |key|
          model.send(key.to_s) != old[key]
        end
      end

      def failure_message
        "expected mass assignment to #{self.keys_as_string} to succeed but it did not"
      end

      def negative_failure_message
        "expected mass assignment to #{self.keys_as_string} to fail but it did not"
      end

      def description
        "allow mass assignment to #{self.keys_as_string}"
      end

      def keys_as_string
        @attributes.keys.join(', ')
      end
    end # class AllowMassAssignmentFor

    def allow_mass_assignment_of hash = nil
      AllowMassAssignmentOf.new hash
    end
  end # module Matchers
end # module RSpec
