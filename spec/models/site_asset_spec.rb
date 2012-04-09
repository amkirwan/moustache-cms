require 'spec_helper'

describe SiteAsset do  
  
  let(:user) { FactoryGirl.create(:user)}
  let(:site) { FactoryGirl.create(:site, :users => [user]) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @ac = FactoryGirl.create(:asset_collection, :site => site, :created_by => user, :updated_by => user)
    @ac.site_assets << @site_asset = FactoryGirl.build(:site_asset, :asset => AssetFixtureHelper.open("rails.png"), :content_type => "image/png")
  end
  
  describe "it should allow mass assignment of the fields" do
    it "should allow mass assignment of" do
      site_asset = SiteAsset.new(:name => "foobar", :content_type => "css", :width => 10, :height => 10, :file_size => 10, :asset => AssetFixtureHelper.open("rails.png"))
      site_asset.name.should == "foobar"
      site_asset.content_type.should == "css"
      site_asset.width.should == 10
      site_asset.height.should == 10
      site_asset.file_size.should == 10
      site_asset.asset.should_not be_nil
    end 
  end
  
  # -- Validations  -----------------------------------------------
  describe "Validation" do    
    it "should not be valid without a asset file" do
      @site_asset.remove_asset!
      @site_asset.should_not be_valid
    end
  end   
  
  # -- Callbacks -----------
  context "before_save" do
    describe "#update_asset_attributes" do
      it "should set the size of the file" do
        @site_asset.file_size.should == AssetFixtureHelper.open('rails.png').size
      end  
      
      it "should set the file content_type" do   
        @site_asset.content_type.should == "image/png"         
      end
    end
  end

  context "before_update" do
    describe "#recreate" do
      it "should update the filename and recreate version when a new name is given" do
        @ac.site_assets.last.update_attributes(:name => "new_name")
        #site_asset = @ac.site_assets.first
        site_asset = AssetCollection.first.site_assets.where(:name => 'new_name').first
        
        site_asset.asset.filename.should == "new_name.png"
      end  
    end
  end
  
  # --  Associations -----------------------------------------------
   describe "associations" do
     it "should be embeeded within a asset_collection" do
       @site_asset.should be_embedded_in(:asset_collection)
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
