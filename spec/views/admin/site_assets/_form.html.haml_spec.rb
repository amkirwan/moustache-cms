require "spec_helper"

describe "admin/site_assets/_form.html.haml" do
  include FormHelpers
    
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:site_asset) { stub_model(SiteAsset, :site => site) }
  let(:asset_collection) { stub_model(AssetCollection) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  def do_render(label)
    render "admin/site_assets/form", :current_site => site, :asset_collection => asset_collection, :site_asset => site_asset, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => site_asset })
  end
  
  context "when the site_asset is NEW" do
    before(:each) do
      site_asset.as_new_record
      do_render("Save Media")
    end
    
    it "should render a button to save the new site_asset" do    
      form_new(:action => admin_asset_collection_site_assets_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save Media")
      end
    end
    
    it "should render a field to enter the name" do
      form_new(:action => admin_asset_collection_site_assets_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "text", :name => "site_asset[name]")
      end
    end
    
    it "should render a field to enter a description" do
      form_new(:action => admin_asset_collection_site_assets_path(asset_collection, site_asset)) do |f|
        f.should have_selector("textarea", :name => "site_asset[description]")
      end
    end
    
    it "should render a field to upload file" do
      form_new(:action => admin_asset_collection_site_assets_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "file", :name => "site_asset[asset]")
      end
    end
    
    it "should render a hidden field to cache the file tmp path on redisplay" do
      form_new(:action => admin_asset_collection_site_assets_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "hidden", :name => "site_asset[asset_cache]")
      end
    end
  end
  
  context "when redisplaying new field form because of validation error should cache the image asset from tmp" do
    before(:each) do
      site_asset.as_new_record
    end
    
    it "should show the cached image" do
      site_asset.stub(:asset? => true)
      site_asset.stub_chain(:asset, :thumb, :url => "/spec/fixtures/assets/rails.png")
      do_render("Save Media")
      rendered.should have_selector("img", :src => "/spec/fixtures/assets/rails.png")
    end
    
    it "should cache the file tmp path on redisplay" do
      site_asset.stub(:asset_cache => "/tmp/rails.png")
      do_render("Save Media")
      form_new(:action => admin_asset_collection_site_assets_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "hidden", :name => "site_asset[asset_cache]", :value => "/tmp/rails.png")
      end
    end
  end
  
  context "when EDITing the site_asset" do
    before(:each) do
      site_asset.stub(:new_record? => false)
      site_asset.stub(:asset_filename => "file.png")
      site_asset.stub_chain(:asset, :url => "/image/path/file.png")
    end
    
    it "should render a button to update the site_asset" do
      do_render("Update Asset")
      form_update(:action => admin_asset_collection_site_asset_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update Asset")
      end
    end
    
    it "should render a field with the site_asset name" do
      site_asset.stub(:name => "foobar")
      do_render("Update Asset")
      form_update(:action => admin_asset_collection_site_asset_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "text", :value => "foobar")      
      end
    end
    
    it "should render a field with the description" do
      site_asset.stub(:description => "foobar description")
      do_render("Update Asset")
      form_update(:action => admin_asset_collection_site_asset_path(asset_collection, site_asset)) do |f|
        f.should have_selector("textarea", :content => "foobar description")
      end
    end
    
    it "should show the name of the file" do
      do_render("Update Asset")
      rendered.should have_selector("a", :content => site_asset.asset_filename, :href => "http://test.host#{site_asset.asset.url}")
    end 
    
    it "should render a hidden field to cache the file on redisplay" do
      do_render("Update Asset")
      form_update(:action => admin_asset_collection_site_asset_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "hidden", :name => "site_asset[asset_cache]")
      end
    end 
    
    it "should render a delete button to destroy the site_asset" do
      do_render("Update Asset")      
      rendered.should have_selector("div#delete_asset") do |div|
        div.should have_selector("input", :type => "hidden", :value => "delete")
        div.should have_selector("input", :type => "submit", :value => "Delete Asset")
      end
    end
  end
  
  context "when redisplaying edit form because of validation error should cache the image asset from tmp" do
    before(:each) do
      site_asset.stub(:new_record? => false)
      site_asset.stub(:asset_filename => "file.png")
    end
    
    it "should show the cached image" do
      site_asset.stub(:asset? => true)
      site_asset.stub_chain(:asset, :url => "/image/path/file.png")
      site_asset.stub_chain(:asset, :thumb, :url => "/spec/fixtures/assets/rails.png")
      do_render("Update Asset")
      rendered.should have_selector("img", :src => "/spec/fixtures/assets/rails.png")
    end
    
    it "should cache the file tmp path on redisplay" do
      site_asset.stub(:asset_cache => "/tmp/rails.png")
      do_render("Update Asset")
      form_update(:action => admin_asset_collection_site_asset_path(asset_collection, site_asset)) do |f|
        f.should have_selector("input", :type => "hidden", :name => "site_asset[asset_cache]", :value => "/tmp/rails.png")
      end
    end
  end
end