require 'spec_helper'

describe ThemeAsset do  
  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user, :site => site) }
  let(:theme_collection) { FactoryGirl.create(:theme_collection, :site => site) }
  
  after(:all) do
    AssetFixtureHelper.reset!
  end

  before(:each) do
    theme_collection.theme_assets << @theme_asset_image = FactoryGirl.build(:theme_asset, :name => "image", :asset => AssetFixtureHelper.open("rails.png"), :content_type => "image/png", :creator_id => user.id, :updator_id => user.id)
    theme_collection.theme_assets << @theme_asset_css = FactoryGirl.build(:theme_asset, :name => "css",  :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css", :creator_id => user.id, :updator_id => user.id)
    theme_collection.theme_assets << @theme_asset_js = FactoryGirl.build(:theme_asset, :name => "js", :asset => AssetFixtureHelper.open("theme_js.js"), :content_type => "application/x-javascript", :creator_id => user.id, :updator_id => user.id)
    theme_collection.theme_assets << @theme_asset_type = FactoryGirl.build(:theme_asset, :name => "other", :asset => AssetFixtureHelper.open("Inconsolata.otf"), :content_type => "application/octet-stream", :creator_id => user.id, :updator_id => user.id)

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
     
     it "should not be valid without a name" do
       @theme_asset_image.name = nil
       @theme_asset_image.should_not be_valid
     end

     it "should not be valid without a asset file" do
       @theme_asset_js.remove_asset!
       @theme_asset_js.should_not be_valid
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
         asset = theme_collection.theme_assets.where(:name => "image").first
         asset.name = "new_name"
         asset.save
         asset = theme_collection.theme_assets.where(:name => "new_name").first
         #asset.name.should == 'new_name'
         #asset.asset_identifier.should == "new_name.png"
         #asset.asset.url.should =~ /new_name.png/
       end  
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

