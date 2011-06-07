# admin::media_files index spec
require 'spec_helper'

describe "admin/asset_collections/index.html.haml" do 
  let(:site) { stub_model(Site) }
  let(:user) { stub_model(User, :puid => "ak730", :site => site) }                                  
  let(:asset_collections) { [stub_model(AssetCollection, :name => "foobar", :created_by => user, :site => site)] }
  
  before(:each) do
    assign(:asset_collections, asset_collections)
    view.stub(:can?).and_return(true)
  end
  
  it "renders a list of admin_site_assets" do
    render
    asset_collections.each do |collection|
      rendered.should have_selector("li##{collection.name}")
    end
  end
  
  it "should render a link to with the collection name to show the assets" do
    render
    asset_collections.each do |collection|
      rendered.should have_selector("li##{collection.name}") do |li|
        li.should have_selector("div") do |div|
          div.should have_selector("a", :content => "#{collection.name}", :href => admin_asset_collection_site_assets_path(collection))
        end
      end
    end
  end
  
  it "should render a delete button to destroy a collection" do
    render
    asset_collections.each do |collection|
      rendered.should have_selector("li##{collection.name}") do |li|
        li.should have_selector("div") do |div|
          div.should have_selector("form", :method => "post", :action => admin_asset_collection_path(collection)) do |form|
            form.should have_selector("input", :value => "delete")
          end          
        end
      end
    end
  end
  
  it "should render a button to create a new asset collection" do
    render
    rendered.should have_selector("ul#new_asset_collection") do |ul|
      ul.should have_selector("li") do |li|
        li.should have_selector("a", :content => "New Collection", :href => new_admin_asset_collection_path)
      end
    end
  end
end