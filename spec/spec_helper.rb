
# This file is copied to spec/ when you run 'rails generate rspec:install'
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
end


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