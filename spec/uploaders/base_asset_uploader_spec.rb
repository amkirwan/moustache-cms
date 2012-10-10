require 'spec_helper'
require "carrierwave/test/matchers"

describe BaseAssetUploader do
  include CarrierWave::Test::Matchers

  let(:site) { FactoryGirl.create(:site) }
  let(:mca) { FactoryGirl.create(:base_asset, site_id: site.id) }
  let(:mca_css) { FactoryGirl.create(:base_asset, site_id: site.id, :asset => AssetFixtureHelper.open("theme_css.css")) } 
  let(:mca_js) { FactoryGirl.create(:base_asset, site_id: site.id, :asset => AssetFixtureHelper.open("theme_js.js")) } 
  let(:mca_otf) { FactoryGirl.create(:base_asset, site_id: site.id, :asset => AssetFixtureHelper.open("Inconsolata.otf")) } 

  before do
    BaseAssetUploader.enable_processing = true
    @uploader = BaseAssetUploader.new(mca, :asset)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))

    @uploader_css = BaseAssetUploader.new(mca_css, :asset)
    @uploader_css.store!(AssetFixtureHelper.open("theme_css.css"))

    @uploader_js = BaseAssetUploader.new(mca_js, :asset)
    @uploader_js.store!(AssetFixtureHelper.open("theme_js.js"))

    @uploader_otf = BaseAssetUploader.new(mca_otf, :asset)
    @uploader_otf.store!(AssetFixtureHelper.open("Inconsolata.otf"))
  end

  after do
    BaseAssetUploader.enable_processing = false
    AssetFixtureHelper.remove_asset!(File.join(Rails.root, 'public', @uploader.store_dir))
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
    @uploader.store_dir.should == "base_assets/#{site.id}"
  end
 
  describe "it should respond true or false to type of asset" do
    it "should return true when the file is an image" do
      @uploader.image?.should be_true
    end

    it "should return true when the file is a stylesheet" do
      @uploader_css.stylesheet?.should be_true
    end

    it "should return true when the file is a javascript file" do
      @uploader_js.javascript?.should be_true
    end
  end 
end
