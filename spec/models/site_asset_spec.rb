require 'spec_helper'

describe SiteAsset do  
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @site_asset = Factory(:site_asset, :site => site, :asset => AssetFixtureHelper.open("rails.png"), :created_by => user, :updated_by => user)
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
    
    it "should not be valid without a asset file" do
      @site_asset.remove_asset!
      @site_asset.should_not be_valid
    end
  end   
  
  # -- Callbacks -----------
  describe "before_save" do
    describe "#update_asset_attributes" do
      it "should set the size of the file" do
        @site_asset.file_size.should == 6646
      end  
      
      it "should set the file content_type" do   
        pending("can only seem to set content_type when uploading")
        @site_asset.content_type.should == "image/png"         
      end
    end
  end
    
  describe "before_update" do
    describe "#recreate" do
      it "should update the filename and recreate version when a new name is given" do
        @site_asset.name = "new_name"
        @site_asset.save
        @site_asset.asset.filename.should == "new_name.png"
        @site_asset.asset.url.should =~ /new_name.png/
      end  
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
   
   # -- Instance Methods ----------
   describe "Instance Methods" do
     describe "#image?" do
       it "should return true that the site_asset is an image" do
         @site_asset.should be_image
       end     
       
       it "should return false when the site_asset is not an image" do 
          site_asset = Factory(:site_asset, :site => site, :asset => AssetFixtureHelper.open("hello.pdf"), :created_by => user, :updated_by => user) 
          site_asset.should_not be_image
       end  
     end
   end
end
