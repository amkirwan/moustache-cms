require 'spec_helper'


describe "AssetCollection" do
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user) }
  
  before(:each) do      
    @asset_collection = Factory(:asset_collection, :site => site, :created_by => user, :updated_by => user)           
  end
  
  # --  Associations ---- 
  describe "associations" do
    it "should belong_to a site" do
      @asset_collection.should belong_to(:site)
    end

    it "should belong_to a user with created_by" do
      @asset_collection.should belong_to(:created_by).of_type(User)
    end

    it "should belong_to a user with updated_by" do
      @asset_collection.should belong_to(:updated_by).of_type(User)
    end
    
    it "should embed many page_parts" do
      @asset_collection.should embed_many :site_assets
    end
  end
  
  # -- Validations ------------
  describe "Validations" do
    it "should create a valid asset_collection" do
      @asset_collection.should be_valid
    end
    
    it "should not be valid without a name" do
      @asset_collection.name = nil
      @asset_collection.should_not be_valid
    end
    
    it "should not be valid without a unique name" do
      Factory.build(:asset_collection, :name => @asset_collection.name, :site => @asset_collection.site).should_not be_valid
    end
    
    it "should not be valid without a site_id" do
      @asset_collection.site_id = nil
      @asset_collection.should_not be_valid
    end
    
    it "should not be valid without created_by" do
      @asset_collection.created_by_id = nil
      @asset_collection.should_not be_valid      
    end
    
    it "should not be valid without updated_by" do
      @asset_collection.updated_by_id = nil
      @asset_collection.should_not be_valid      
    end
  end
  
end