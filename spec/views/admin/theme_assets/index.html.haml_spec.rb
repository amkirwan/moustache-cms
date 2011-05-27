# admin::theme_asset index spec
require 'spec_helper'

describe "admin/theme_assets/index.html.haml" do
  let(:theme_assets) { [stub_model(ThemeAsset, :name => "foobar")] }
  
  before(:each) do
    assign(:theme_assets, theme_assets)
    theme_assets.stub(:css_files => theme_assets)
    theme_assets.stub(:js_files => theme_assets)
    theme_assets.stub(:images => theme_assets)
  end
  
  describe "css section" do
    
    it "should make the css filename a clickable link to edit" do
      render 
      theme_assets.css_files.each do |css|
        rendered.should have_selector("li##{css.name}") do |li|
          li.should have_selector("a", :content => "#{css.name}", :href => edit_admin_theme_asset_path(css))
        end
      end
    end
    
    it "should render a delete button to destroy the css file" do
      render
      theme_assets.css_files.each do |css|
        rendered.should have_selector("li##{css.name}") do |li|
          li.should have_selector("input", :value => "delete")
        end
      end      
    end  
  end
  
  describe "javascript section" do

    it "should make the javascript filename a clickable link to edit" do
      render 
      theme_assets.js_files.each do |js|
        rendered.should have_selector("li##{js.name}") do |li|
          li.should have_selector("a", :content => "#{js.name}", :href => edit_admin_theme_asset_path(js))
        end
      end
    end
    
    it "should render a delete button to destroy the javascript file" do
      render
      theme_assets.js_files.each do |js|
        rendered.should have_selector("li##{js.name}") do |li|
          li.should have_selector("input", :value => "delete")
        end
      end      
    end  
  end
  
  describe "image section" do
    
    it "should make the image filename a clickable link to edit" do
      render 
      theme_assets.images.each do |image|
        rendered.should have_selector("li##{image.name}") do |li|
          li.should have_selector("a", :content => "#{image.name}", :href => edit_admin_theme_asset_path(image))
        end
      end
    end
    
    it "should render a delete button to destroy the image file" do
      render
      theme_assets.images.each do |image|
        rendered.should have_selector("li##{image.name}") do |li|
          li.should have_selector("input", :value => "delete")
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