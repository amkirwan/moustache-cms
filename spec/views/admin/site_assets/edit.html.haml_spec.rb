require 'spec_helper'

describe "admin/site_assets/edit.html.haml" do
  let(:site_asset) { stub_model(SiteAsset, :name => "foobar") }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:site_asset, site_asset)
    assign(:current_user, current_user)
  end

  it "renders the edit site_asset form" do
    render
    rendered.should have_selector("h3", :content => "Edit Asset #{site_asset.name.humanize}")
  end
  
  it "should render the form partial to edit the media file" do
    render
    view.should render_template(:partial => "form", :locals => {:site_asset => site_asset, :button_label => "Update Asset" })
  end
end
