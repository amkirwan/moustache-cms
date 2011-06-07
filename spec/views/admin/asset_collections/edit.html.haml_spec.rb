#EDIT asset_collection
require 'spec_helper'


describe "admin/asset_collections/edit.html.haml" do
  let(:asset_collection) { Factory(:asset_collection) }
  
  before(:each) do
    assign(:asset_collection, asset_collection)
  end
  
  it "should render an h3 heading" do
    render
    rendered.should have_selector("h3", :content => "Edit Asset Collection")
  end
  
  it "should render the form partial" do
    render
    view.should render_template(:partial => "form", :locals => { :button_label => "Update Collection" })
  end
  
end