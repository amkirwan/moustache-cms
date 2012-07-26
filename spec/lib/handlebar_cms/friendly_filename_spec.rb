require 'spec_helper'

describe MoustacheCms::FriendlyFilename  do
  class DummyClass
    include Mongoid::Document
    include MoustacheCms::FriendlyFilename

    field :name
    mount_uploader :asset, SiteAssetUploader
  end

  class DummyController < ActionController::Base
    include MoustacheCms::FriendlyFilename
  end

  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_controller = DummyController.new
  end

  describe "filename" do
    it "should define a filename attribute for the model" do
      @dummy_class.should respond_to(:filename)
    end

    it "should not define a filename attribute for the controller" do
      @dummy_controller.should_not respond_to(:filename)
    end
  end

  describe "#friendly_filename" do
    it "should create a friendly directory name from the name" do
      @dummy_class.name = 'foo bar'
      @dummy_class.friendly_filename
      @dummy_class.filename.should == 'foo_bar'
    end
  end 

end
