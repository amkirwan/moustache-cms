# admin::asset_collections show spec
require 'spec_helper'

describe "admin/asset_collections/show.html.haml" do
  let(:site) { stub_model(Site) }
  let(:user) { stub_model(User, :puid => "ak730") }
  let(:asset_collection) { stub_model(AssetCollection, :name => "foobar", 
                                                       :created_by => user,
                                                       :site => site,
                                                       :site_assets => [stub_model(SiteAsset, :name => "foobar", :created_by => user)]) }
  
  before(:each) do
    assign(:asset_collection, asset_collection)
    view.stub(:can?).and_return(true)
  end
  
  
  # -- Manage Collection Links
  describe "manage collection links" do
    it "should render the link to edit the collections properties" do
      render
      rendered.should have_selector("div#manage_collection > ul") do |ul|
        ul.should have_selector("li") do |li|
          li.should have_selector("a", :content => "edit collection properties", :href => edit_admin_asset_collection_path(asset_collection))
        end
      end
    end

    it "should render the link to destroy the collection" do
      render
      rendered.should have_selector("div#manage_collection > ul") do |ul|
        ul.should have_selector("li") do |li|
          li.should have_selector("form", :method => "post", :action => admin_asset_collection_path(asset_collection)) do |form|
            form.should have_selector("input", :value => "delete collection")
            form.should have_selector("input", :value => "delete")
          end
        end
      end
    end   
  end
  
  it "should render the asset_collection" do
    render
    rendered.should have_selector("div#collection_#{asset_collection.name}")
  end
  
  it "should render a link to edit the file" do
    render
    asset_collection.site_assets.each do |asset|
      rendered.should have_selector("ul#assets") do |ul|
        #ul.should have_selector("li#asset_#{asset.id}")
      end
    end
  end
  
  it "should render all the assets of the collection" do
    render
    asset_collection.site_assets.each do |asset|
      rendered.should have_selector("li#asset_#{asset.id}")
    end
  end
  
  it "should render a header with the asset name link to edit the element" do
    render
    asset_collection.site_assets.each do |asset|
      rendered.should have_selector("li#asset_#{asset.id} > h5") do |h5|
        h5.should have_selector("a", :content => "foobar", :href => edit_admin_asset_collection_site_asset_path(asset_collection, asset))
      end
    end
  end
end