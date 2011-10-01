require 'spec_helper'

describe ElementAttr do

  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }

  before(:each) do
    @theme_asset_attr = Factory.build(:element_attr)
  end

  # -- Validations --
  describe "Validation" do
    it "should be valid" do
      @theme_asset_attr.should be_valid
    end
  end


  # -- Associations ---
  describe "Association" do 
    it "should be embedded in a theme_asset" do
      @theme_asset_attr.should be_embedded_in(:theme_asset)
    end
  end
end
