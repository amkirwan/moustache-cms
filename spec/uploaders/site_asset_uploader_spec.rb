require "spec_helper"
require "carrierwave/test/matchers"

describe SiteAssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:user) { FactoryGirl.create(:user) }
  let(:site) { FactoryGirl.create(:site, :users => [user]) }
  let(:site_asset) { FactoryGirl.build(:site_asset, :name => "foobar") }  
  let(:asset_collection) { FactoryGirl.create(:asset_collection, :site => site, :site_assets => [site_asset], :created_by => user, :updated_by => user)}
  
  before do
    SiteAssetUploader.enable_processing = true
    @uploader = SiteAssetUploader.new(asset_collection.site_assets.first, :asset)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
  end
  
  after do
    SiteAssetUploader.enable_processing = false
    @uploader.remove!
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
    @uploader.store_dir.should == "site_assets/#{@uploader.model._parent.site_id}/#{@uploader.model._parent.name}"
  end
  
  it "should change the uploaded filename to the name of the site_asset" do
    @uploader.filename.should =~  /^foobar.png$/
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png pdf mp4 m4v ogv webm flv otf)
  end       
  
  
  it "should return true when the file is an image" do
    @uploader.image?(@uploader.file).should be_true
  end
end
