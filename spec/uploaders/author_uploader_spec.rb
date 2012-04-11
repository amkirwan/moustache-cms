require 'spec_helper'
require "carrierwave/test/matchers"

describe AuthorUploader do
  include CarrierWave::Test::Matchers
  
  let(:user) { FactoryGirl.create(:user) }
  let(:site) { FactoryGirl.create(:site, :users => [user]) }
  let(:author) { FactoryGirl.build(:author, :firstname => "Anthony", :middlename => '', :lastname => "Kirwan") }  
  
  before do
    AuthorUploader.enable_processing = true
    @uploader = AuthorUploader.new(author, :image)
    @uploader.store!(AssetFixtureHelper.open("rails.png"))
  end
  
  after do
    AuthorUploader.enable_processing = false
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'authors', @uploader.model.site_id.to_s))
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
  
  it "should change the uploaded filename to the name of the full_name of the author" do
    @uploader.filename.should ==  "anthony-kirwan.png"
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png)
  end       
  
  it "should return true when the file is an image" do
    @uploader.image?(@uploader.file).should be_true
  end
  
  describe "storeage paths" do
    
    it "should set the storage directory to image for image files" do
      @uploader.store_dir.should == "authors/#{@uploader.model.site_id}"
    end
  end
end

