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
end
