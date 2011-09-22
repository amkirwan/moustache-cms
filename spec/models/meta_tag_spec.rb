require "spec_helper"

describe MetaTag do 

  before(:each) do
    @meta_tag = Factory.build(:meta_tag)
  end

  # -- Associations --
  describe "Associations" do
    it "should be embedded in meta_taggable" do
      @meta_tag.should be_embedded_in(:meta_taggable)
    end
  end

  # -- Validations --
  describe "Validations" do
    it "should be a valid meta tag" do
      @meta_tag.should be_valid
    end

    it "should not be valid without a name" do
      @meta_tag.name = nil
      @meta_tag.should_not be_valid
    end

    it "should not be valid without content" do
      @meta_tag.content = nil
      @meta_tag.should_not be_valid
    end
  end
end
