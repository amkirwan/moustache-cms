require 'spec_helper'

describe BaseAsset do

  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @mca = FactoryGirl.create(:base_asset)
  end

  # -- Validations  -----------------------------------------------
  describe "Validation" do    
     it "should be valid" do
       @mca.should be_valid
     end    

    it "should not be valid without a asset file" do
       @mca.validates_presence_of(:name)
    end

    it "should not be valid without a asset" do
       @mca.validates_presence_of(:asset)
    end
  end   

  # -- Callbacks -----------
  describe "before validations" do
    describe "#set_name" do
      it "should set the asset name to the name of the file if it is blank" do
        @mca.name = nil
        @mca.save
        @mca.name.should == "asset_name"
      end
    end
  end

  describe "before_save" do
    describe "#update_asset_attributes" do
      it "should set the size of the file" do
        @mca.file_size.should == AssetFixtureHelper.open('rails.png').size
      end  
      
      it "should set the file content_type" do   
        @mca.content_type.should == "image/png"         
      end
    end
  end

  describe "before_update" do
    describe "#recreate" do
      it "should update the filename and recreate version when a new name is given" do
        @mca.update_attributes(:name => "new_name")
        @mca.asset.filename.should == "new_name.png"
      end  
    end
  end
  
end
