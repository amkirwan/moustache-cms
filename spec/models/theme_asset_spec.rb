require 'spec_helper'

describe ThemeAsset do  
  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user, :site => site) }
  let(:theme_collection) { FactoryGirl.create(:theme_collection, :site => site) }

  before(:all) do
    FactoryGirl.duplicate_attribute_assignment_from_initialize_with = false
  end
  
  after(:all) do
    AssetFixtureHelper.reset!
    FactoryGirl.duplicate_attribute_assignment_from_initialize_with = true
  end

  before(:each) do
    @theme_collection = theme_collection
    theme_collection.theme_assets << @theme_asset_image = FactoryGirl.build(:theme_asset, :name => "image", :asset => AssetFixtureHelper.open("rails.png"), :content_type => "image/png", :creator_id => user.id, :updator_id => user.id)
    theme_collection.theme_assets << @theme_asset_css = FactoryGirl.build(:theme_asset, :name => "css",  :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css", :creator_id => user.id, :updator_id => user.id)
    theme_collection.theme_assets << @theme_asset_js = FactoryGirl.build(:theme_asset, :name => "js", :asset => AssetFixtureHelper.open("theme_js.js"), :creator_id => user.id, :updator_id => user.id, :content_type => 'text/javascript')
    theme_collection.theme_assets << @theme_asset_type = FactoryGirl.build(:theme_asset, :name => "other", :asset => AssetFixtureHelper.open("Inconsolata.otf"), :content_type => "application/octet-stream", :creator_id => user.id, :updator_id => user.id)

  end
  
  after(:each) do
    remove_theme_assets
  end
  # --  Associations -----------------------------------------------
   describe "associations" do
     it "shouldbe embedded_in the article_collection" do
       @theme_asset_css.should be_embedded_in(:article_collection)
     end

     it "should embed many custom_fields as custom_fieldable" do
      @theme_asset_css.should embed_many(:custom_fields)
     end
   end
   
   # -- Validations  -----------------------------------------------
   describe "Validation" do
     it "should be valid" do
       @theme_asset_image.should be_valid
     end    
   end
     
   # -- Scopes ------------------------------------------------------
   describe "scopes" do
     describe "css_files" do
       it "should return all the theme assets css files" do
         css_files = theme_collection.theme_assets.css_files
         css_files.size.should == 1
         css_files.first.should == @theme_asset_css
       end
       
       it "should return empty Criteria if it cannot find any css files in the theme" do
         theme_collection.theme_assets.find(@theme_asset_css.id).delete
         theme_collection.theme_assets.css_files.should be_empty
       end
     end
     
     describe "js_files" do
       it "should return all the theme assets js files" do
         js_files = theme_collection.theme_assets.js_files
         js_files.size.should == 1
         js_files.first.should == @theme_asset_js
       end

       it "should return empty Criteria if it cannot find any js files in the theme" do
         theme_collection.theme_assets.find(@theme_asset_js.id).delete
         theme_collection.theme_assets.js_files.should be_empty
       end  
     end   
     
     describe "images" do
       it "should return all the theme image files" do
         images = theme_collection.theme_assets.images
         images.size.should == 1
         images.first.should == @theme_asset_image
       end

       it "should return empty Criteria if it cannot find any images in the theme" do
         theme_collection.theme_assets.find(@theme_asset_image.id).delete
         theme_collection.theme_assets.images.should be_empty
       end  
     end

     describe "should return the theme assets that are not css, javascript or images" do
       it "should return all the other theme asset files" do
         other = theme_collection.theme_assets.other_files
         other.size.should == 1
         other.last.should == @theme_asset_type
       end
     end
     
     describe "find_by_name" do
       it "should return the asset by name" do
         theme_collection.theme_assets.find_by_name("css").first.should == @theme_asset_css
       end
     end
   end 
   
   # -- Class Methods ------------------------
   describe "Dynamic Scoped for content_type" do
     it "should return all the theme assets css files" do
       css_files = theme_collection.theme_assets.find_by_content_type_and_site_id(:content_type => "text/css", :site_id => site.id)
       css_files.size.should == 1
       css_files.first.should == @theme_asset_css
     end

     it "should return empty Criteria if it cannot find the domain" do
       theme_collection.theme_assets.find(@theme_asset_css.id).delete
       theme_collection.theme_assets.find_by_content_type_and_site_id(:content_type => "text/css", :site_id => site.id).should be_empty
     end   

     it "should return all the image files" do
       theme_collection.theme_assets.images.count.should == 1
     end
   end
   
   # -- Instance Methods ----------
   describe "Instance Methods" do
     describe "#update_file_content" do
       it "should return when true when saving the updated file content" do
          @theme_asset_css.update_file_content("hello, world").should be_true
       end
     end

   end
end

