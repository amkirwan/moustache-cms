require "spec_helper"

describe "admin/theme_assets/_new_theme_asset.html.haml" do
  include FormHelpers
    
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:theme_asset) { stub_model(ThemeAsset, :site => site) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:current_site, site)
    assign(:theme_asset, theme_asset)
    assign(:current_user, current_user)
    form_for([:admin, theme_asset]) do |f|
      @f = f
    end
  end
  
  def do_render
    render "admin/theme_assets/new_theme_asset", :new_theme_asset => @f, :theme_asset => theme_asset
  end
  
  context "when the theme_asset is NEW" do
    before(:each) do
      theme_asset.as_new_record
      do_render
    end

    it "should render a field to upload file" do
      rendered.should have_selector("input", :type => "file", :name => "theme_asset[asset]")
    end

    it "should render a hidden field to cache the file tmp path on redisplay" do
      rendered.should have_selector("input", :type => "hidden", :name => "theme_asset[asset_cache]")
    end
  end
  
  context "when redisplaying new field form because of validation error should cache the image asset from tmp" do
    before(:each) do
      theme_asset.as_new_record
    end
    
    it "should show the cached image" do
      theme_asset.stub(:asset? => true)
      theme_asset.stub_chain(:asset, :thumb, :url => "/spec/fixtures/assets/rails.png")
      do_render
      rendered.should have_selector("img", :src => "/spec/fixtures/assets/rails.png")
    end
    
    it "should cache the file tmp path on redisplay" do
      theme_asset.stub(:asset_cache => "/tmp/rails.png")
      do_render
      rendered.should have_selector("input", :type => "hidden", :name => "theme_asset[asset_cache]", :value => "/tmp/rails.png")
    end
  end
end