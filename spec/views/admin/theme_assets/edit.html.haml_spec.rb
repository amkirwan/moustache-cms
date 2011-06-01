# edit css file spec
require "spec_helper"

describe "admin/theme_assets/edit.html.haml" do
  
  let(:theme_asset) { stub_model(ThemeAsset, :name => "foobar") }
  let(:current_user) { stub_model(User, :role? => true) }
   
  before(:each) do 
    assign(:theme_asset, theme_asset)
    assign(:current_user, current_user)
  end
  
  it "should render form title" do
    render
    rendered.should have_selector("h3", :content => "Edit Theme Asset #{theme_asset.name}")
  end
  
  it "should render partial form with button to update theme asset" do
    render
    view.should  render_template(:partial => "form", :locals => { :theme_asset => theme_asset, :button_label => "Update Theme Asset" })
  end  
end