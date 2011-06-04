require "spec_helper"
require "carrierwave/test/matchers"

describe ThemeAssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:site) { Factory(:site) }
  let(:theme_asset) { Factory(:theme_asset, :name => "foobar", :site => site) }
  let(:theme_asset_css) { Factory(:theme_asset, :name => "foobar", :site => site, :asset => AssetFixtureHelper.open("theme_css.css")) }
  let(:theme_asset_js) { Factory(:theme_asset, :name => "foobar", :site => site, :asset => AssetFixtureHelper.open("theme_js.js")) }
  let(:theme_asset_otf) { Factory(:theme_asset, :name => "foobar", :site => site, :asset => AssetFixtureHelper.open("Inconsolata.otf")) }
  
  before do
    ThemeAssetUploader.enable_processing = true
    @uploader = ThemeAssetUploader.new(theme_asset, :asset)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
  end
  
  after do
    @uploader.remove!
    SiteAssetUploader.enable_processing = false
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
      @uploader_css = ThemeAssetUploader.new(theme_asset_css, :asset)
      @uploader_css.store!(AssetFixtureHelper.open("theme_css.css"))
      @uploader_js = ThemeAssetUploader.new(theme_asset_js, :asset)
      @uploader_js.store!(AssetFixtureHelper.open("theme_js.js"))
      @uploader_otf = ThemeAssetUploader.new(theme_asset_otf, :asset)
      @uploader_otf.store!(AssetFixtureHelper.open("Inconsolata.otf"))
    end
    
    it "should set the storage directory to image for image files" do
      @uploader.store_dir.should == "sites/#{@uploader.model.site_id}/#{@uploader.model.class.to_s.underscore}/images"
    end
    
    it "should set the storage dir to stylesheet for css files" do
      @uploader_css.store_dir.should == "sites/#{@uploader_css.model.site_id}/#{@uploader_css.model.class.to_s.underscore}/stylesheets"
    end
    
    it "should set the storage dir to javascript for js files" do
      @uploader_js.store_dir.should == "sites/#{@uploader_js.model.site_id}/#{@uploader_js.model.class.to_s.underscore}/javascripts"
    end
    
    it "should set the storage dir to asset for other files" do
      @uploader_otf.store_dir.should == "sites/#{@uploader_otf.model.site_id}/#{@uploader_otf.model.class.to_s.underscore}/assets"
    end
  end
end