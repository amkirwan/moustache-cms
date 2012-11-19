require 'spec_helper'

describe MoustacheAsset do

  let(:site) { FactoryGirl.create(:site) }

  after(:all) do
    AssetFixtureHelper.reset!
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'moustache_assets'))
  end

  before do
    BaseAssetUploader.enable_processing = true
  end

  before(:each) do
    @moustache_asset = FactoryGirl.create(:moustache_asset)
    @moustache_asset_css = FactoryGirl.create(:moustache_asset, site_id: site.id, :asset => AssetFixtureHelper.open("theme_css.css"))  
    @moustache_asset_js = FactoryGirl.create(:moustache_asset, site_id: site.id, :asset => AssetFixtureHelper.open("theme_js.js")) 
  end

  # -- Validations  -----------------------------------------------
  describe "Validation" do    
     it "should be valid" do
       @moustache_asset.should be_valid
     end    

    it "should not be valid without a asset file" do
       @moustache_asset.validates_presence_of(:name)
    end

    it "should not be valid without a asset" do
       @moustache_asset.validates_presence_of(:asset)
    end
  end   

  # -- Callbacks -----------
  describe "before validations" do
    describe "#set_name" do
      it "should set the asset name to the name of the file if it is blank" do
        @moustache_asset.name = nil
        @moustache_asset.save
        @moustache_asset.name.should == "asset_name.png"
      end
    end
  end

  describe "before_save" do
    describe "#update_asset_attributes" do
      it "should set the size of the file" do
        @moustache_asset.file_size.should == AssetFixtureHelper.open('rails.png').size
      end  
      
      it "should set the file content_type" do   
        @moustache_asset.content_type.should == "image/png"         
      end
    end
  end

  describe "before_update" do
    describe "#recreate" do
      it "should update the filename and recreate version when a new name is given" do
        @moustache_asset.update_attributes(:name => "new_name")
        @moustache_asset.asset.filename.should == "new_name"
      end  
    end
  end

  describe "asset_type" do
    it "#image?" do
      @uploader = BaseAssetUploader.new(@moustache_asset, :asset)
      @uploader.store!(AssetFixtureHelper.open("rails.png"))
      @moustache_asset.should be_image
    end

    it "#stylesheet?" do
      @uploader_css = BaseAssetUploader.new(@moustache_asset_css, :asset)
      @uploader_css.store!(AssetFixtureHelper.open("theme_css.css"))
      @moustache_asset_css.should be_stylesheet  
    end

    it "#javascript?" do
      @uploader_js = BaseAssetUploader.new(@moustache_asset_js, :asset)
      @uploader_js.store!(AssetFixtureHelper.open("theme_js.js"))
      @moustache_asset_js.should be_javascript
    end
  end

end
