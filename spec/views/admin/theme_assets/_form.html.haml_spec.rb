require "spec_helper"

describe "admin/theme_assets/_form.html.haml" do
  include FormHelpers
    
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:theme_asset) { stub_model(ThemeAsset, :site => site) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:current_site, site)
    assign(:theme_asset, theme_asset)
    assign(:current_user, current_user)
    view.stub(:can?).and_return(true)
  end
  
  def do_render(label)
    render "admin/theme_assets/form", :theme_asset => theme_asset, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => theme_asset })
  end
  
  # -- NEW ---
  context "when the theme_asset is NEW" do
    before(:each) do
      theme_asset.as_new_record
      do_render("Save Theme Asset")
    end
    
    it "should render a button to save the new theme_asset" do    
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save Theme Asset")
      end
    end
    
    it "should render a field to enter the name" do
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("input", :type => "text", :name => "theme_asset[name]")
      end
    end
    
    it "should render a field to enter a description" do
      form_new(:action => admin_theme_assets_path) do |f|
        f.should have_selector("textarea", :name => "theme_asset[description]")
      end
    end
    
    it "should render the new_theme_asset partial" do
      do_render("Save Theme Asset")
      view.should render_template(:partial => "_new_theme_asset", :locals => { :theme_asset => theme_asset })
    end  
    
    it "should render an additional options text field" do
      form_new(:action => admin_theme_assets_path) do |f| 
        f.should have_selector("input", :type => "text", :name => "theme_asset[html_options]")
      end
    end
    
    it "should not render a delete link to delete for a new theme_asset" do
      do_render("Save Asset")      
      rendered.should_not have_selector("div#delete_asset")
    end
  end
  
  # -- Existing Record ------
  context "when EDITing the theme_asset image" do
    before(:each) do
      theme_asset.stub(:new_record? => false, :image? => true)
    end
    
    it "should render a button to update the theme_asset" do
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update Theme Asset")
      end
    end
    
    it "should render a field with the theme_asset name" do
      theme_asset.stub(:name => "foobar")
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "text", :value => "foobar")      
      end
    end
    
    it "should render a field with the description" do
      theme_asset.stub(:description => "foobar description")
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("textarea", :content => "foobar description")
      end
    end
    
    it "should render the image_asset partial" do
      do_render("Update Theme Asset")
      view.should render_template(:partial => "image_asset", :locals => { :theme_asset => theme_asset })
    end
  end  
  
  context "when EDITing a theme stylesheet or javascript" do
    before(:each) do
      theme_asset.stub(:new_record? => false, :image? => false, :stylesheet? => true)
    end
    
    it "should render a button to update the theme_asset" do
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update Theme Asset")
      end
    end
    
    it "should render a field with the theme_asset name" do
      theme_asset.stub(:name => "foobar")
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "text", :value => "foobar")      
      end
    end
    
    it "should render a field with the description" do
      theme_asset.stub(:description => "foobar description")
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("textarea", :content => "foobar description")
      end
    end      
    
    it "should render an html options text field" do
      theme_asset.stub(:html_options => "media='all'")
      do_render("Update Theme Asset")
      form_update(:action => admin_theme_asset_path(theme_asset)) do |f|
        f.should have_selector("input", :type => "text", :value => "media='all'")
      end
    end
    
    it "should render a delete link to delete the site_asset" do
      do_render("Update Theme Asset")      
      rendered.should have_selector("div#delete_asset") do |div|
        div.should have_selector("a", :content => "Delete Asset", :href => admin_theme_asset_path(theme_asset))
      end
    end
    
    it "should not render a delete link to delete the site_asset if can? returns false" do
      view.stub(:can?).and_return(false)
      do_render("Update Theme Asset")      
      rendered.should_not have_selector("div#delete_asset")
    end
    
    it "should render the image_asset partial" do
      do_render("Update Theme Asset")
      view.should render_template(:partial => "css_js_asset", :locals => { :theme_asset => theme_asset })
    end
  end                                                          
end