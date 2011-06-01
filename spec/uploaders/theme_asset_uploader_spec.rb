require "spec_helper"
require "carrierwave/test/matchers"

describe SiteAssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:theme_asset) { ThemeAsset.new(:name => "foobar", :content_type => "image/png") }
  
  before do
    ThemeAssetUploader.enable_processing = true
    @uploader = ThemeAssetUploader.new(theme_asset, :source)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
  end
  
  after do
    @uploader.remove!
    SiteAssetUploader.enable_processing = false
  end
  
  it "should set the storage directory" do
    @uploader.store_dir.should == "sites/#{@uploader.model.site_id}/#{@uploader.model.class.to_s.underscore}/#{@uploader.mounted_as}/#{@uploader.model.id}"
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
    uploader = ThemeAssetUploader.new(theme_asset, :source)
    uploader.store!(AssetFixtureHelper.open("theme_css.css"))
    uploader.thumb.should be_blank
  end
  
  it "should return true when the file is an image" do
    @uploader.image?(@uploader.file).should be_true
  end
end