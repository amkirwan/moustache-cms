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

                  
  it "should change the uploaded filename to the name of the full_name of the author" do
    @uploader.filename.should ==  "anthony-kirwan.png"
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png)
  end       
  
  it "should set the storage directory for the authors directory" do
    @uploader.store_dir.should == "authors/#{@uploader.model.site_id}"
  end

end

