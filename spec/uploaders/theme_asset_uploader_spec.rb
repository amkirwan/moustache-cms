require "spec_helper"
require "carrierwave/test/matchers"

describe ThemeAssetUploader do
  include CarrierWave::Test::Matchers

  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user, :site => site) }
  let(:theme_collection) { FactoryGirl.create(:theme_collection, :site => site) }
  
  before do
    theme_collection.theme_assets << @theme_asset = FactoryGirl.build(:theme_asset, :name => "foobar", content_type: 'png/image') 
    theme_collection.theme_assets << @theme_asset_css = FactoryGirl.build(:theme_asset, :name => "foobar", :asset => AssetFixtureHelper.open("theme_css.css"), content_type: 'text/css') 
    theme_collection.theme_assets << @theme_asset_js = FactoryGirl.build(:theme_asset, :name => "foobar", :asset => AssetFixtureHelper.open("theme_js.js"), content_type: 'text/javascript') 
    theme_collection.theme_assets << @theme_asset_otf = FactoryGirl.build(:theme_asset, :name => "foobar", :asset => AssetFixtureHelper.open("Inconsolata.otf"), content_type: 'application/x-font-opentype')
    
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
  
  after(:each) do
    ThemeAssetUploader.enable_processing = false
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', theme_collection.site_id.to_s))
    # FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', @uploader.model.site_id.to_s))
    # FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', @uploader_css.model.site_id.to_s))
    # FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', @uploader_js.model.site_id.to_s))
    # FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', @uploader_otf.model.site_id.to_s))
  end  
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png css js swf flv eot svg ttf woff otf ico pdf mp4 m4v ogv webm flv)
  end       
 
  describe "set the directory asset type for storing the file in" do
    it "should return images if the file is an image file" do
      @uploader.asset_type.should == 'images'
    end

    it "should return javascripts if the file is a javascript file" do
      @uploader_js.asset_type.should == 'javascripts'
    end

    it "should return stylesheets if the file is a css file" do
      @uploader_css.asset_type.should == 'stylesheets'
    end

    it "should return assets fi the file is not a image, javascript or css file" do
      @uploader_otf.asset_type.should == 'assets'
    end
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
