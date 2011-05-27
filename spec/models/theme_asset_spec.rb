require 'spec_helper'

describe SiteAsset do  
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @theme_asset = Factory(:theme_asset, :site => site, :source => AssetFixtureHelper.open("rails.png"), :created_by => user, :updated_by => user)
  end
  
  
  # --  Associations -----------------------------------------------
   describe "associations" do
     it "should belong_to a site" do
       @theme_asset.should belong_to(:site)
     end

     it "should belong_to a user with created_by" do
       @theme_asset.should belong_to(:created_by).of_type(User)
     end

     it "should belong_to a user with updated_by" do
       @theme_asset.should belong_to(:updated_by).of_type(User)
     end
   end
end