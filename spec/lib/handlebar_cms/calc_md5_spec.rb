require 'spec_helper'

describe MoustacheCms::CalcMd5 do
  class DummyClass
    include Mongoid::Document
    include MoustacheCms::CalcMd5

    field :name
    field :content_type
    field :width, :type => Integer
    field :height, :type => Integer
    field :file_size, :type => Integer
    field :creator_id
    field :updator_id
    mount_uploader :asset, SiteAssetUploader
  end

  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @site = FactoryGirl.create(:site)
    @user = FactoryGirl.create(:user, :site => @site)
    @ac = FactoryGirl.create(:asset_collection, :site => @site, :created_by => @user, :updated_by => @user)
    @ac.site_assets << @site_asset = FactoryGirl.build(:site_asset, :asset => AssetFixtureHelper.open("rails.png"), :content_type => "image/png")
  end

  after(:each) do
    site_remove_assets(@site)
  end

  describe "#calc_md5" do
    it "should generate an md5 filename on the file contents" do
      hex = ::Digest::MD5.hexdigest(AssetFixtureHelper.open('rails.png').read)
      @site_asset.filename_md5.should =~ /.*#{hex}\.png/
    end

    it "should generate a md5 file path" do
      hex = ::Digest::MD5.hexdigest(AssetFixtureHelper.open('rails.png').read)
      @site_asset.file_path_md5.should == "#{Rails.root}/public/#{@site_asset.asset.store_dir}/#{@site_asset.filename_md5}"
    end
  end

  describe "#move_file_md5" do
    it "should renmae the file" do
      pending
    end
  end

  describe "#destroy_md5" do
    it "should destroy the md5 file" do
      pending
    end
  end

end
