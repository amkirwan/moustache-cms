require 'spec_helper'

describe SiteAsset do  
  
  let(:user) { FactoryGirl.create(:user)}
  let(:site) { FactoryGirl.create(:site, :users => [user]) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @ac = FactoryGirl.create(:asset_collection, :site => site)
    @ac.site_assets << @site_asset = FactoryGirl.build(:site_asset, :asset => AssetFixtureHelper.open("rails.png"), :content_type => "image/png")
  end
  
  after(:each) do
    remove_site_assets
  end

  # --  Associations -----------------------------------------------
   describe "associations" do
     it "should be embeeded within a asset_collection" do
       @site_asset.should be_embedded_in(:asset_collection)
     end                     
   end 

   # -- Validations  -----------------------------------------------
   describe "Validation" do
     it "should be valid" do
       @site_asset.should be_valid
     end    
   end
   
  # -- Instance Methods ----------
  context "Instance Methods" do
    describe "#image?" do
      it "should return true that the site_asset is an image" do
        @site_asset.should be_image
      end     
      
      it "should return false when the site_asset is not an image" do 
         site_asset = FactoryGirl.build(:site_asset, :asset => AssetFixtureHelper.open("hello.pdf"))
         site_asset.should_not be_image
      end  
    end

  end

end
