require 'spec_helper'

describe MoustacheCms::CalcMd5 do
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

  describe "CalcMd5#set_asset_folder" do
    it "should set the asset_folder" do
      @site_asset.asset_folder.should == 'site_assets'  
    end

    it "should ovrride the default asset_folder" do
      @site_asset.asset_folder = 'foobar'
      @site_asset.asset_folder.should == 'foobar'
    end
  end

  describe "#calc_md5" do
    it "should generate an md5 filename on the file contents" do
      hex = ::Digest::MD5.hexdigest(AssetFixtureHelper.open('rails.png').read)
      @site_asset.filename_md5.should =~ /.*#{hex}\.png/
    end
  end

  describe "#current_path_md5" do
    it "should return the curent path to the md5 file" do
      @site_asset.current_path_md5.should == "#{Rails.root}/public/#{@site_asset.asset.store_dir}/#{@site_asset.filename_md5}"
    end
  end

  describe "#store_dir_md5" do
    it "should return the storage directory of the md5 file" do
      @site_asset.store_dir_md5.should == @site_asset.asset.store_dir
    end
  end

  describe "#store" do
    it "should return the storage path of the md5 file" do
      @site_asset.store_path_md5.should == File.join(@site_asset.asset.store_dir, @site_asset.filename_md5)
    end  
  end

  describe "#destroy_md5" do
    it "should destroy the md5 file" do
      pending
    end
  end

end
