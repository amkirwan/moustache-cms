require "spec_helper"
require "carrierwave/test/matchers"

describe ThemeAssetUploader do
  include CarrierWave::Test::Matchers

  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user, :site => site) }
  let(:theme_collection) { FactoryGirl.create(:theme_collection, :site => site) }
  
  before do
    theme_collection.theme_assets << @theme_asset = FactoryGirl.build(:theme_asset, :name => "foobar") 
    theme_collection.theme_assets << @theme_asset_css = FactoryGirl.build(:theme_asset, :name => "foobar", :asset => AssetFixtureHelper.open("theme_css.css")) 
    theme_collection.theme_assets << @theme_asset_js = FactoryGirl.build(:theme_asset, :name => "foobar", :asset => AssetFixtureHelper.open("theme_js.js")) 
    theme_collection.theme_assets << @theme_asset_otf = FactoryGirl.build(:theme_asset, :name => "foobar", :asset => AssetFixtureHelper.open("Inconsolata.otf"))
    
    ThemeAssetUploader.enable_processing = true
    @uploader = ThemeAssetUploader.new(@theme_asset, :asset)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
    @uploader_css = ThemeAssetUploader.new(@theme_asset_css, :asset)
    @uploader_css.store!(AssetFixtureHelper.open("theme_css.css"))
    @uploader_js = ThemeAssetUploader.new(@theme_asset_js, :asset)
    @uploader_js.store!(AssetFixtureHelper.open("theme_js.js"))
    @uploader_otf = ThemeAssetUploader.new(@theme_asset_otf, :asset)
    @uploader_otf.store!(AssetFixtureHelper.open("Inconsolata.otf"))
  end
  
  after do
    ThemeAssetUploader.enable_processing = false
    AssetFixtureHelper.remove_asset!(@uploader)
  end  
  
  describe "before_filer" do
    describe "#remember_cache_id" do
      it "should assign file cache_id" do
        @uploader.instance_variable_get(:@cache_id_was).should_not be_nil
      end  
    end                    
  end                                                                  
       
  describe "after_filter" do
    describe "delete_tmp_dir" do
      it "should delete the tmp directory" do     
        File.exist?(File.join(Rails.root, "spec", "tmp", @uploader.cache_dir, @uploader.instance_variable_get(:@cache_id_was))).should be_false
      end
    end  
  end                   
  
  it "should change the uploaded filename to the name of the theme_asset" do
    @uploader.filename.should =~  /^foobar.png$/
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png css js swf flv eot svg ttf woff otf ico pdf mp4 m4v ogv webm flv)
  end       
  
  it "should return true when the file is an image" do
    @uploader.image?(@uploader.file).should be_true
  end
  
  describe "storeage paths" do
   
    it "should set the storage directory to image for image files" do
      @uploader.store_dir.should == "theme_assets/#{@uploader.model._parent.site_id}/#{@uploader.model._parent.name}/images"
    end
    
    it "should set the storage dir to stylesheet for css files" do
      @uploader_css.store_dir.should == "theme_assets/#{@uploader.model._parent.site_id}/#{@uploader.model._parent.name}/stylesheets"
    end
    
    it "should set the storage dir to javascript for js files" do
      @uploader_js.store_dir.should == "theme_assets/#{@uploader.model._parent.site_id}/#{@uploader.model._parent.name}/javascripts"
    end
    
    it "should set the storage dir to asset for other files" do
      @uploader_otf.store_dir.should == "theme_assets/#{@uploader.model._parent.site_id}/#{@uploader.model._parent.name}/assets"
    end
  end
end
