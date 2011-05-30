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
   
   # -- Callbacks -----------
   describe "before_save" do
     describe "#update_asset_attributes" do
       it "should set the size of the file" do
         @theme_asset_image.file_size.should == 6646
       end  

       it "should set the file content_type" do   
         pending("can only seem to set content_type when uploading")
         @theme_asset_image.content_type.should == "image/png"         
       end
     end
   end

   describe "before_update" do
     describe "#recreate" do
       it "should update the filename and recreate version when a new name is given" do
         @theme_asset_image.name = "new_name"
         @theme_asset_image.save
         theme_image = ThemeAsset.where(:name => "new_name", :site_id => site.id).first
         theme_image.source_filename.should == "new_name.png"
         theme_image.source.url.should =~ /new_name.png/
       end  
     end
   end
   
   # -- Scopes ------------------------------------------------------
   describe "scopes" do
     describe "css_files" do
       it "should return all the theme assets css files" do
         css_files = ThemeAsset.css_files(site)
         css_files.size.should == 1
         css_files.first.should == @theme_asset_css
       end

       it "should return empty Criteria if it cannot find any css files in the theme" do
         @theme_asset_css.delete(site)
         ThemeAsset.css_files(site).should be_empty
       end
     end
     
     describe "js_files" do
       it "should return all the theme assets js files" do
         js_files = ThemeAsset.js_files(site)
         js_files.size.should == 1
         js_files.first.should == @theme_asset_js
       end

       it "should return empty Criteria if it cannot find any js files in the theme" do
         @theme_asset_js.delete(site)
         ThemeAsset.js_files(site).should be_empty
       end  
     end   
     
     describe "images" do
       it "should return all the theme image files" do
         images = ThemeAsset.images(site)
         images.size.should == 1
         images.first.should == @theme_asset_image
       end

       it "should return empty Criteria if it cannot find any images in the theme" do
         @theme_asset_image.delete(site)
         ThemeAsset.images(site).should be_empty
       end  
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