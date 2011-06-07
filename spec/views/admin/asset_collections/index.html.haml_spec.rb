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
  
  it "should render a link to show the asset collections nested collection" do
    render
    asset_collections.each do |collection|
      rendered.should have_selector("li##{collection.name}") do |li|
        li.should have_selector("div") do |div|
          div.should have_selector("a", :content => "#{collection.name}", :href => admin_asset_collection_path)
        end
      end
    end
  end
end