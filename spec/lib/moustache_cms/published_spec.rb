require 'spec_helper'

describe MoustacheCms::Published do
  class PublishedDummy
    include Mongoid::Document  
    embeds_one :current_state 
  end

  before(:each) do
    @dummy_class = PublishedDummy.new
    @dummy_class.current_state = FactoryGirl.build(:current_state)
    @dummy_class.extend(MoustacheCms::Published)
  end

  describe "#published?" do
    it "should return true when the page's current state is published" do
      @dummy_class.published?.should be_true
    end

    it "should return false when the page's current state is not published" do
      @dummy_class.current_state.name = "draft"
      @dummy_class.published?.should be_false
    end
  end

  describe "#draft?" do
    it "should return true when the page's current state is draft" do
      @dummy_class.current_state.name = "draft"
      @dummy_class.draft?.should be_true
    end

    it "should return false when the page's current state is not draft" do
      @dummy_class.draft?.should be_false
    end
  end

  describe "#published_on" do
    it "shortcut to the current_state published_at property" do
      @dummy_class.published_on.should == @dummy_class.current_state.published_on
    end
  end

end
