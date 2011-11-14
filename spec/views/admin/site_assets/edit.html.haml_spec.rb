require 'spec_helper'

describe "admin/site_assets/edit.html.haml" do
  let(:site_asset) { stub_model(SiteAsset, :name => "foobar") }
  let(:asset_collection) { stub_model(AssetCollection) }
  let(:current_site) { stub_model(Site)}
  let(:current_admin_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:asset_collection, asset_collection)
    assign(:current_site, current_site)
    assign(:site_asset, site_asset)
    assign(:current_admin_user, current_admin_user)
  end

  it "renders the edit site_asset form" do
    render
    rendered.should have_selector("h3", :content => "Edit Asset #{site_asset.name.humanize}")
  end
  
  it "should render the form partial to edit the media file" do
    render
    view.should render_template(:partial => "form", :locals => {:current_site => current_site, :asset_collection => asset_collection, :site_asset => site_asset, :button_label => "Update Asset" })
  end
end
