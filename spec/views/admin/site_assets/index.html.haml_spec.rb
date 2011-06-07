# admin::site_assets index spec
require 'spec_helper'

describe "admin/site_assets/index.html.haml" do
  let(:user) { stub_model(User, :puid => "ak730") }
  let(:site_assets) { [stub_model(SiteAsset, :name => "foobar", :created_by => user), stub_model(SiteAsset, :name => "foo", :created_by => user)] }
  
  before(:each) do
    assign(:site_assets, site_assets)
    view.stub(:can?).and_return(true)
  end

  it "renders a list of admin_site_assets" do
    render
    site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
      end
    end
  end
  
  it "should render a link to edit the file" do
    render
    site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
        li.should have_selector("div") do |div|
          div.should have_selector("a", :content => "#{asset.name}", :href => edit_admin_site_asset_path(asset))
        end
      end
    end
  end
  
  it "should render the username for the person who created the file" do
    render
    site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
        li.should have_selector("div", :content => "#{asset.created_by.puid}")
      end
    end
  end
  
  it "should render a delete button to destroy the asset file" do
    render
    site_assets.each do |asset|
      rendered.should have_selector("li##{asset.name}") do |li|
        li.should have_selector("div") do |div|   
          div.should have_selector("form", :method => "post", :action => admin_site_asset_path(asset)) do |form|
            form.should have_selector("input", :value => "delete")
          end   
        end
      end
    end
  end
  
  it "should render a link to add a new asset file" do
    render
    rendered.should have_selector("ul#new_site_asset") do |ul|
      ul.should have_selector("li") do |li|
        li.should have_selector("a", :content => "Add Asset", :href => new_admin_site_asset_path)
      end
    end
  end

end
