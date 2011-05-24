require 'spec_helper'

describe SiteAsset do  
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @site_asset = Factory(:site_asset, :site => site, :source => AssetFixtureHelper.open("rails.png"), :created_by => user, :updated_by => user)
  end
  
  describe "it should allow mass assignment of the fields" do
    it "should allow mass assignment of" do
      site_asset = SiteAsset.new(:name => "foobar", :content_type => "css", :width => 10, :height => 10, :size => 10, :source => AssetFixtureHelper.open("rails.png"))
      site_asset.name.should == "foobar"
      site_asset.content_type.should == "css"
      site_asset.width.should == 10
      site_asset.height.should == 10
      site_asset.size.should == 10
      site_asset.source.should_not be_nil
    end 
  end
  
  # -- Validations  -----------------------------------------------
  describe "Validation" do
    it "should be valid" do
      @site_asset.should be_valid
    end
    
    it "should not be valid without a name" do
      @site_asset.name = nil
      @site_asset.should_not be_valid
    end
    
    it "should not be valid without an associated site" do
      @site_asset.site = nil
      @site_asset.should_not be_valid
    end
    
    it "should not be valid without a source file" do
      @site_asset.remove_source!
      @site_asset.should_not be_valid
    end
  end
  
  # --  Associations -----------------------------------------------
   describe "associations" do
     it "should belong_to a site" do
       @site_asset.should belong_to(:site)
     end

     it "should belong_to a user with created_by" do
       @site_asset.should belong_to(:created_by).of_type(User)
     end

     it "should belong_to a user with updated_by" do
       @site_asset.should belong_to(:updated_by).of_type(User)
     end
   end
end
