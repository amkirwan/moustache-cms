require "spec_helper"

describe "admin/theme_assets/_image_asset.html.haml" do
    
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
    render "admin/theme_assets/image_asset", :image_asset => @f, :theme_asset => theme_asset
  end
  
  context "when editing a theme_asset image" do    
    it "should show the location of the file" do
      theme_asset.stub_chain(:asset, :url => "/image/path/file.png")
      do_render
      rendered.should have_selector("a", :content => "http://#{site.full_subdomain}#{theme_asset.asset.url}")
    end 

    it "should render a hidden field to cache the file on redisplay" do
      do_render
      rendered.should have_selector("input", :type => "hidden", :name => "theme_asset[asset_cache]")
    end 
  end
  
  context "when redisplaying edit form because of validation error should cache the image asset from tmp" do
    before(:each) do
      theme_asset.stub(:new_record? => false)
    end
    
    it "should show the cached image" do
      theme_asset.stub(:asset? => true)
      theme_asset.stub_chain(:asset, :url => "/image/path/file.png")
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