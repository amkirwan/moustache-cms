# model spec for MetaTag
require "spec_helper"

describe "MetaData" do
  before(:each) do
    @meta = Factory.build(:meta_data)
  end
  
  describe "after_initialize callback" do
    describe "default_keys" do
      it "should create the title tag" do
        @meta.tags.should have_key(:title)
      end
      
      it "should create the keywords tag" do
        @meta.tags.should have_key(:keywords)
      end
      
      it "should create the description tag" do
        @meta.tags.should have_key(:description)
      end
    end
  end
  
  describe "should be able to add new meta tags" do
    it "should alllow DC core tags" do
      @meta.tags["DC.creator"] = "foobar"
      @meta.tags.should have_key("DC.creator")
    end
  end
end