require "spec_helper"
require "carrierwave/test/matchers"

describe SiteAssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:site) { Factory(:site) }
  let(:theme_asset) { ThemeAsset.new(:name => "foobar", :site => site) }
  
  before do
    ThemeAssetUploader.enable_processing = true
    @uploader = ThemeAssetUploader.new(theme_asset, :asset)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
  end
  
  after do
    @uploader.remove!
    SiteAssetUploader.enable_processing = false
  end
  
  it "should change the uploaded filename to the name of the theme_asset" do
    @uploader.filename.should == "foobar.png"
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png css js swf flv eot svg ttf woff otf ico)
  end       
  
  it "should make a thumbnail exactly 80 by 80 pixels" do
    @uploader.thumb.should have_dimensions(80, 80)
  end
  
  it "should not make a thumbnail when content_type is not an image" do
    uploader = ThemeAssetUploader.new(theme_asset, :asset)
    uploader.store!(AssetFixtureHelper.open("theme_css.css"))
    uploader.thumb.should be_blank
  end
  
  it "should return true when the file is an image" do
    @uploader.image?(@uploader.file).should be_true
  end
  
  describe "storeage paths" do
    before(:each) do
      @uploader_css = ThemeAssetUploader.new(theme_asset, :asset)
      @uploader_css.store!(AssetFixtureHelper.open("theme_css.css"))
      @uploader_js = ThemeAssetUploader.new(theme_asset, :asset)
      @uploader_js.store!(AssetFixtureHelper.open("theme_js.js"))
      @uploader_asset = ThemeAssetUploader.new(theme_asset, :asset)
      @uploader_asset.store!(AssetFixtureHelper.open("LindenHill.otf"))
    end
    
    it "should set the storage directory to image for image files" do
      pending("can't set model in spec")
      @uploader.store_dir.should == "sites/#{@uploader.model.site_id}/#{@uploader.model.class.to_s.underscore}/images/#{@uploader.model.id}"
    end
    
    it "should set the storage dir to stylesheet for css files" do
      pending("can't set model in spec")
      @uploader_css.store_dir.should == "sites/#{@uploader_css.model.site_id}/#{@uploader_css.model.class.to_s.underscore}/stylesheets/#{@uploader_css.model.id}"
    end
    
    it "should set the storage dir to javascript for js files" do
      pending("can't set model in spec")
      @uploader_js.store_dir.should == "sites/#{@uploader_js.model.site_id}/#{@uploader_js.model.class.to_s.underscore}/javascripts/#{@uploader_js.model.id}"
    end
    
    it "should set the storage dir to asset for other files" do
      pending("can't set model in spec")
      @uploader_asset.store_dir.should == "sites/#{@uploader_asset.model.site_id}/#{@uploader_asset.model.class.to_s.underscore}/assets/#{@uploader_asset.model.id}"
    end
  end
end