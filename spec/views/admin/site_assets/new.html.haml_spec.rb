# NEW media_files
require 'spec_helper'

describe "admin/site_assets/new.html.haml" do
  let(:site_asset) { stub_model(SiteAsset) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:site_asset, site_asset.as_new_record)
    assign(:current_user, current_user)
  end

  it "renders new site_asset form" do
    render
    rendered.should have_selector("h3", :content => "Create New Asset")
  end
  
  it "should render the form partial" do
    render
    view.should render_template(:partial => "form", :locals => { :site_asset => site_asset, :button_label => "Save Asset" })
  end
end
