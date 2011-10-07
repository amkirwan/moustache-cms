require 'spec_helper'

describe TagAttr do

  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }

  before(:each) do
    @tag_attr = Factory.build(:tag_attr)
  end

  # -- Validations --
  describe "Validation" do
    it "should be valid" do
      @tag_attr.should be_valid
    end
  end


  # -- Associations ---
  describe "Association" do 
    it "should be embedded in a tag_attr" do
      @tag_attr.should be_embedded_in(:tag_attrable)
    end
  end
end
