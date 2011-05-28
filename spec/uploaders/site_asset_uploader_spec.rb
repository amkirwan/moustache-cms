require "spec_helper"
require "carrierwave/test/matchers"

describe SiteAssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:site_asset) { SiteAsset.new(:name => "foobar", :content_type => "image/png") }
  
  before do
    SiteAssetUploader.enable_processing = true
    @uploader = SiteAssetUploader.new(site_asset, :source)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
  end
  
  after do
    @uploader.remove!
    SiteAssetUploader.enable_processing = false
  end
  
  it "should change the uploaded filename to the name of the site_asset" do
    @uploader.filename.should == "foobar.png"
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png pdf swf flv svg)
  end       
  
  it "should make a thumbnail exactly 50 by 50 pixels" do
    @uploader.thumb.should have_dimensions(50, 50)
  end
  
  it "should return true when the file is an image" do
    @uploader.image?(site_asset).should == true
  end
end