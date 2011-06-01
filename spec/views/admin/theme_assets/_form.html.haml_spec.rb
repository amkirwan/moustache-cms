require "spec_helper"

describe "admin/theme_assets/_form.html.haml" do
  include FormHelpers
    
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:theme_asset) { stub_model(ThemeAsset, :site => site) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:current_site, site)
    assign(:theme_asset, theme_asset)
    assign(:current_user, current_user)
  end
  
  def do_render(label)
    render "admin/theme_assets/form", :theme_asset => theme_asset, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => theme_asset })
  end
  
  context "when the theme_asset is NEW" do
    before(:each) do
      theme_asset.as_new_record
      do_render("Save Theme Asset")
    end
    
    it "should render a button to save the new theme_asset" do    
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save Theme Asset")
      end
    end
    
    it "should render a field to enter the name" do
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("input", :type => "text", :name => "theme_asset[name]")
      end
    end
    
    it "should render a field to enter a description" do
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("textarea", :name => "theme_asset[description]")
      end
    end
    
    it "should render a field to upload file" do
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("input", :type => "file", :name => "theme_asset[asset]")
      end
    end
    
    it "should render a hidden field to cache the file tmp path on redisplay" do
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("input", :type => "hidden", :name => "theme_asset[asset_cache]")
      end
    end
  end
  
  context "when redisplaying new field form because of validation error should cache the image asset from tmp" do
    before(:each) do
      theme_asset.as_new_record
    end
    
    it "should show the cached image" do
      theme_asset.stub(:asset? => true)
      theme_asset.stub_chain(:asset, :thumb, :url => "/spec/fixtures/assets/rails.png")
      do_render("Save Theme Asset")
      rendered.should have_selector("img", :src => "/spec/fixtures/assets/rails.png")
    end
    
    it "should cache the file tmp path on redisplay" do
      theme_asset.stub(:asset_cache => "/tmp/rails.png")
      do_render("Save Theme Asset")
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("input", :type => "hidden", :name => "theme_asset[asset_cache]", :value => "/tmp/rails.png")
      end
    end
  end
  
  context "when EDITing the theme_asset" do
    before(:each) do
      theme_asset.stub(:new_record? => false)
    end
    
    it "should render a button to update the theme_asset" do
      do_render("Update Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update Theme Asset")
      end
    end
    
    it "should render a field with the theme_asset name" do
      theme_asset.stub(:name => "foobar")
      do_render("Update Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "text", :value => "foobar")      
      end
    end
    
    it "should render a field with the description" do
      theme_asset.stub(:description => "foobar description")
      do_render("Update Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("textarea", :content => "foobar description")
      end
    end
    
    it "should show the location of the file" do
      theme_asset.stub_chain(:asset, :url => "/image/path/file.png")
      do_render("Update Asset")
      rendered.should have_selector("a", :content => "http://#{site.full_subdomain}#{theme_asset.asset.url}")
    end 
    
    it "should render a hidden field to cache the file on redisplay" do
      do_render("Update Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "hidden", :name => "theme_asset[asset_cache]")
      end
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
      do_render("Update Theme Asset")
      rendered.should have_selector("img", :src => "/spec/fixtures/assets/rails.png")
    end
    
    it "should cache the file tmp path on redisplay" do
      theme_asset.stub(:asset_cache => "/tmp/rails.png")
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "hidden", :name => "theme_asset[asset_cache]", :value => "/tmp/rails.png")
      end
    end
  end
end