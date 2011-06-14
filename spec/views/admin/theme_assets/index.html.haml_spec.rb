# admin::theme_asset index spec
require 'spec_helper'

describe "admin/theme_assets/index.html.haml" do
  let(:theme_assets) { [stub_model(ThemeAsset, :name => "foobar")] }
  let(:css_files) { [ stub_model(ThemeAsset, :name => "foobar")] }
  let(:js_files) { [ stub_model(ThemeAsset, :name => "foobar")] }
  let(:images) { [ stub_model(ThemeAsset, :name => "foobar")] }
  
  before(:each) do
    assign(:theme_assets, theme_assets)
    assign(:css_files, css_files)
    assign(:js_files, js_files)
    assign(:images, images)
  end
  
  describe "css section" do
    
    it "should make the css filename a clickable link to edit" do
      render 
      css_files.each do |css|
        rendered.should have_selector("li##{css.name}") do |li|
          li.should have_selector("a", :content => "#{css.name}", :href => edit_admin_theme_asset_path(css))
        end
      end
    end
    
    it "should render a delete button to destroy the css file" do
      render
      css_files.each do |css|
        rendered.should have_selector("li##{css.name}") do |li|
          li.should have_selector("a", :content => "Delete", :href => admin_theme_asset_path(css))
        end
      end      
    end  
  end
  
  describe "javascript section" do

    it "should make the javascript filename a clickable link to edit" do
      render 
      js_files.each do |js|
        rendered.should have_selector("li##{js.name}") do |li|
          li.should have_selector("a", :content => "#{js.name}", :href => edit_admin_theme_asset_path(js))
        end
      end
    end
    
    it "should render a delete button to destroy the javascript file" do
      render
      js_files.each do |js|
        rendered.should have_selector("li##{js.name}") do |li|
          li.should have_selector("a", :content => "Delete", :href => admin_theme_asset_path(js))
        end
      end      
    end  
  end
  
  describe "image section" do
    
    it "should make the image filename a clickable link to edit" do
      render 
      images.each do |image|
        rendered.should have_selector("li##{image.name}") do |li|
          li.should have_selector("a", :content => "#{image.name}", :href => edit_admin_theme_asset_path(image))
        end
      end
    end
    
    it "should render a delete button to destroy the image file" do
      render
      images.each do |image|
        rendered.should have_selector("li##{image.name}") do |li|
          li.should have_selector("a", :content => "Delete", :href => admin_theme_asset_path(image))
        end
      end      
    end  
  end
   
  it "should render a link to add a new page" do
    render
    rendered.should have_selector("a", :href => new_admin_theme_asset_path) do |link|
      link.should contain("Add Theme Asset")
    end
  end
  
end