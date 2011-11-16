# admin::site_assets index spec
require 'spec_helper'

describe "admin/site_assets/index.html.haml" do
  let(:user) { stub_model(User, :username => "ak730") }
  let(:site_assets) { [stub_model(SiteAsset, :name => "foobar")] }
  let(:asset_collection) { stub_model(AssetCollection, :site_assets => site_assets) }
  
  before(:each) do        
    assign(:asset_collection, asset_collection)
    assign(:site_assets, site_assets)
    view.stub(:can?).and_return(true)
  end

  it "renders a list of admin_site_assets" do
    render
    asset_collection.site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
      end
    end
  end
  
  it "should render a link to edit the file" do
    render
    asset_collection.site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
        li.should have_selector("div") do |div|
          div.should have_selector("a", :content => "#{asset.name}", :href => edit_admin_asset_collection_site_asset_path(asset_collection, asset))
        end
      end
    end
  end
  
  it "should render a delete button to destroy the asset file" do
    render
    asset_collection.site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
        li.should have_selector("div") do |div|   
          div.should have_selector("a", :content => "delete", :href => admin_asset_collection_site_asset_path(asset_collection, asset))
        end
      end
    end
  end
  
  it "should not render a delete button to destroy the asset file when can? returns false" do
    view.stub(:can?).and_return(false)
    render
    asset_collection.site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
        li.should have_selector("div") do |div|   
          div.should_not have_selector("a", :content => "delete", :href => admin_asset_collection_site_asset_path(asset_collection, asset))
        end
      end
    end
  end
  
  it "should render a link to add a new asset file" do
    render
    rendered.should have_selector("ul#new_site_asset") do |ul|
      ul.should have_selector("li") do |li|
        li.should have_selector("a", :content => "Add Asset", :href => new_admin_asset_collection_site_asset_path(asset_collection))
      end
    end
  end

end
