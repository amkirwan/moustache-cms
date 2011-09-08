require 'spec_helper'

describe ThemeAsset do  
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    @theme_asset_image = Factory(:theme_asset, :name => "image", :site_id => site.id, :asset => AssetFixtureHelper.open("rails.png"), :content_type => "image/png", :created_by_id => user.id, :updated_by_id => user.id)
    @theme_asset_css = Factory(:theme_asset, :name => "css", :site_id => site.id, :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css", :created_by_id => user.id, :updated_by_id => user.id)
    @theme_asset_js = Factory(:theme_asset, :name => "js", :site_id => site.id, :asset => AssetFixtureHelper.open("theme_js.js"), :content_type => "text/javascript", :created_by_id => user.id, :updated_by_id => user.id)
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
   
   # -- Validations  -----------------------------------------------
   describe "Validation" do
     it "should be valid" do
       @theme_asset_image.should be_valid
     end    
     
     it "should not be valid without as site_id" do
       @theme_asset_image.site_id = nil
       @theme_asset_image.should_not be_valid
     end

     it "should not be valid without a name" do
       @theme_asset_image.name = nil
       @theme_asset_image.should_not be_valid
     end

     it "should not be valid without a asset file" do
       @theme_asset_image.remove_asset!
       @theme_asset_image.should_not be_valid
     end
   end
   
   # -- Callbacks -----------
   describe "before_save" do
     describe "#update_asset_attributes" do
       it "should set the size of the file" do
         @theme_asset_image.file_size.should == 6646
       end  

       it "should set the file content_type" do   
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
         theme_image.asset_identifier.should == "new_name.png"
         theme_image.asset.url.should =~ /new_name.png/
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
         site.theme_assets.find(@theme_asset_css.id).delete
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
         site.theme_assets.find(@theme_asset_js.id).delete
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
         site.theme_assets.find(@theme_asset_image.id).delete
         ThemeAsset.images(site).should be_empty
       end  
     end
     
     describe "find_by_name" do
       it "should return the asset by name" do
         ThemeAsset.find_by_name("css").first.should == @theme_asset_css
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
       site.theme_assets.find(@theme_asset_css.id).delete
       ThemeAsset.find_by_content_type_and_site_id(:content_type => "text/css", :site_id => site.id).should be_empty
     end   
   end
   
   # -- Instance Methods ----------
   describe "Instance Methods" do
     describe "#image?" do
       it "should return true that the theme_asset is an image" do
         @theme_asset_image.should be_image
       end     
       
       it "should return false when the site_asset is not an image" do  
          @theme_asset_css.image?.should be_false
       end  
     end 
     
     describe "#update_file_content" do
       it "should return when true when saving the updated file content" do
          @theme_asset_css.update_file_content("hello, world").should be_true
       end
     end
   end
end

















