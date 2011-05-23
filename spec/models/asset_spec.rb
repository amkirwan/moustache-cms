require 'spec_helper'

describe Asset do  
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @asset = Factory(:asset, :site => site, :source => AssetFixtureHelper.open("rails.png"), :created_by => user, :updated_by => user)
  end
  
  describe "it should allow mass assignment of the fields" do
    it "should allow mass assignment of" do
      asset = Asset.new(:name => "foobar", :content_type => "css", :width => 10, :height => 10, :size => 10, :source => AssetFixtureHelper.open("rails.png"))
      asset.name.should == "foobar"
      asset.content_type.should == "css"
      asset.width.should == 10
      asset.height.should == 10
      asset.size.should == 10
      asset.source.should_not be_nil
    end 
  end
  
  # -- Validations  -----------------------------------------------
  describe "Validation" do
    it "should be valid" do
      @asset.should be_valid
    end
    
    it "should not be valid without a name" do
      @asset.name = nil
      @asset.should_not be_valid
    end
    
    it "should not be valid without an associated site" do
      @asset.site = nil
      @asset.should_not be_valid
    end
    
    it "should not be valid without a source file" do
      @asset.remove_source!
      @asset.should_not be_valid
    end
  end
  
  # --  Associations -----------------------------------------------
   describe "associations" do
     it "should belong_to a site" do
       @asset.should belong_to(:site)
     end

     it "should belong_to a user with created_by" do
       @asset.should belong_to(:created_by).of_type(User)
     end

     it "should belong_to a user with updated_by" do
       @asset.should belong_to(:updated_by).of_type(User)
     end
   end
end
