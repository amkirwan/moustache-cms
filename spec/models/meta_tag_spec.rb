require "spec_helper"

describe MetaTag do 

  before(:each) do
    @meta_tag = FactoryGirl.build(:meta_tag)
  end

  # -- Associations --
  describe "Associations" do
    it "should be embedded in meta_taggable" do
      @meta_tag.should be_embedded_in(:meta_taggable)
    end
  end

  # -- before filter
  describe "before save" do
    it "should format the name to replace dashes with underscores" do
      page = FactoryGirl.create(:page)
      @meta_tag.name = 'foo-bar'
      page.meta_tags << @meta_tag
      @meta_tag.name.should == 'foo_bar'
    end
  end
end
