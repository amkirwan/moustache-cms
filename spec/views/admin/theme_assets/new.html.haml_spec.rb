require "spec_helper"

describe "admin/theme_assets/new.html.haml" do
  
  let(:theme_asset) { stub_model(ThemeAsset) }
  let(:current_user) { stub_model(User, :role? => true) }
   
  before(:each) do 
    assign(:theme_asset, theme_asset)
    assign(:current_user, current_user)
  end
  
  it "should render form name" do
    render
    rendered.should have_selector("h3", :content => "Create Theme Asset")
  end
  
  it "should render partial form with button to save new theme asset" do
    render
    view.should  render_template(:partial => "form", :locals => { :theme_asset => theme_asset, :button_label => "Save Theme Asset" })
  end
  
end