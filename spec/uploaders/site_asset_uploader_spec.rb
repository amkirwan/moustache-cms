require "spec_helper"
require "carrierwave/test/matchers"

describe SiteAssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:site) { Factory(:site) }
  let(:site_asset) { Factory(:theme_asset, :name => "foobar", :site_id => site.id) }  
  
  before do
    SiteAssetUploader.enable_processing = true
    @uploader = SiteAssetUploader.new(site_asset, :asset)
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
  
  it "should set the storage directory" do
    @uploader.store_dir.should == "sites/#{@uploader.model.site_id}/#{@uploader.model.class.to_s.underscore}/#{@uploader.mounted_as}/#{@uploader.model.id}"
  end
  
  it "should change the uploaded filename to the name of the site_asset" do
    @uploader.filename.should == "foobar.png"
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png pdf swf flv svg)
  end       
  
  it "should make a thumbnail exactly 50 by 50 pixels when content_type is an image" do
    @uploader.thumb.should have_dimensions(50, 50)
  end
  
  it "should not make a thumbnail when content_type is not an image" do
    uploader = SiteAssetUploader.new(site_asset, :asset)
    uploader.store!(AssetFixtureHelper.open("hello.pdf"))
    uploader.thumb.should be_blank
  end
  
  it "should return true when the file is an image" do
    @uploader.image?(@uploader.file).should be_true
  end
end