require "spec_helper"

describe "admin/theme_assets/_css_js_asset.html.haml" do
  include FormHelpers
    
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:theme_asset) { stub_model(ThemeAsset, :site => site) }
  let(:current_admin_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:current_site, site)
    assign(:theme_asset, theme_asset)
    assign(:current_admin_user, current_admin_user)
    form_for([:admin, theme_asset]) do |f|
      @f = f
    end                   
    theme_asset.stub_chain(:asset, :read => "Hello, World!")
    theme_asset.stub_chain(:asset, :url => "/stylesheet/master.css")
  end
  
  def do_render
    render "admin/theme_assets/css_js_asset", :css_js_asset => @f, :theme_asset => theme_asset
  end
  
  context "when editing a css_js_asset file" do                                       
    it "should show the location of the file" do 
      do_render
      rendered.should have_selector("a", :content => "http://#{site.full_subdomain}#{theme_asset.asset.url}")
    end 

    it "should render a text_area to display to file content" do
      do_render
      rendered.should have_selector("textarea", :name => "theme_asset_file_content", :content => "Hello, World!")
    end 
  end   
end