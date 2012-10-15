require 'spec_helper'
require "carrierwave/test/matchers"

describe BaseAssetUploader do
  include CarrierWave::Test::Matchers

  let(:site) { FactoryGirl.create(:site) }
  let(:mca) { FactoryGirl.create(:moustache_asset, site_id: site.id) }
  let(:folder) { 'moustache_assets' }
  before do
    BaseAssetUploader.enable_processing = true
    @uploader = BaseAssetUploader.new(mca, :asset)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
  end

  after do
    BaseAssetUploader.enable_processing = false
    AssetFixtureHelper.remove_asset!(File.join(Rails.root, 'public', @uploader.store_dir))
    FileUtils.rm_rf(File.join(Rails.root, 'public', folder))
  end 

  describe "before_filter" do
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
    @uploader.store_dir.should == "#{folder}/#{site.id}"
  end
   
end
