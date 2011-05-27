require 'spec_helper'

describe SiteAsset do  
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @theme_asset_image = Factory(:theme_asset, :site => site, :source => AssetFixtureHelper.open("rails.png"), :content_type => "image/png", :created_by => user, :updated_by => user)
    @theme_asset_css = Factory(:theme_asset, :site => site, :source => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css", :created_by => user, :updated_by => user)
    @theme_asset_css.content_type = "text/css"
    @theme_asset_js = Factory(:theme_asset, :site => site, :source => AssetFixtureHelper.open("theme_js.js"), :content_type => "text/javascript", :created_by => user, :updated_by => user)
    @theme_assets = ThemeAsset.all
  end
  
  
  # --  Associations -----------------------------------------------
   describe "associations" do
     it "should belong_to a site" do
       @theme_asset_image.should belong_to(:site)
     end

     it "should belong_to a user with created_by" do
       @theme_asset_image.should belong_to(:created_by).of_type(User)
     end

     it "should belong_to a user with updated_by" do
       @theme_asset_image.should belong_to(:updated_by).of_type(User)
     end
   end
   
   # -- Scopes ------------------------------------------------------
   describe "css_files" do
     it "should return all the theme assets css files" do
       css_files = ThemeAsset.css_files(site)
       css_files.size.should == 1
       css_files.first.should == @theme_asset_css
     end

     it "should return empty Criteria if it cannot find the domain" do
       @theme_asset_css.delete(site)
       ThemeAsset.css_files(site).should be_empty
     end
   end
   
   # -- Class Methods ------------------------
   describe "Dynamic Scoped for content_type" do
     it "should return all the theme assets css files" do
       css_files = ThemeAsset.find_by_content_type_and_site_id(:content_type => "text/css", :site_id => site.id)
       css_files.size.should == 1
       css_files.first.should == @theme_asset_css
     end

     it "should return empty Criteria if it cannot find the domain" do
       @theme_asset_css.delete(site)
       ThemeAsset.find_by_content_type_and_site_id(:content_type => "text/css", :site_id => site.id).should be_empty
     end
     
   end
end