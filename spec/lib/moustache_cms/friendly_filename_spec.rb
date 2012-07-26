require 'spec_helper'

describe MoustacheCms::FriendlyFilename  do
  class DummyClass
    include Mongoid::Document
    include MoustacheCms::FriendlyFilename

    field :name
  end

  class DummyController < ActionController::Base
    include MoustacheCms::FriendlyFilename
  end

  before(:each) do
    @dummy_class = DummyClass.new(:name => 'foo bar')
    @dummy_controller = DummyController.new
  end

  describe "#before_save" do
    it "should define a before_save callback" do
      @dummy_class.save
      @dummy_class.name.should == 'foo_bar'
    end

    it "should not define a filename attribute for the controller" do
      @dummy_controller.should_not respond_to(:filename)
    end
  end

  describe "#friendly_filename" do
    it "should create a friendly directory name from the name" do
      @dummy_class.name = 'foo bar'
      @dummy_class.friendly_filename
      @dummy_class.name.should == 'foo_bar'
    end
  end 

end
