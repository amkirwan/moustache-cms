# NEW asset_collection
require 'spec_helper'

describe "admin/asset_collections/new.html.haml" do
  
  let(:asset_collection) { stub_model(AssetCollection) }
  
  before(:each) do
    assign(:asset_collection, asset_collection.as_new_record)
  end
  
  it "should render heading to create new asset collection" do
    render
    rendered.should have_selector("h3", :content => "Create Asset Collection" )
  end
  
  it "should render the form partial" do
    render
    view.should render_template(:partial => "form", :locals => { :button_label => "Save Collection" })
  end
  
end