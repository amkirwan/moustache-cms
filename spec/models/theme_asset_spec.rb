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
    theme_collection.theme_assets << @theme_asset_image = FactoryGirl.build(:theme_asset, filename: 'rails.png')
    theme_collection.theme_assets << @theme_asset_css = FactoryGirl.build(:theme_asset, filename: 'theme_css.css')
    theme_collection.theme_assets << @theme_asset_js = FactoryGirl.build(:theme_asset, filename: 'theme_js.js')
    theme_collection.theme_assets << @theme_asset_other = FactoryGirl.build(:theme_asset, filename: 'Inconsolata.otf')
  end

  # -- Validations  -----------------------------------------------
  describe "Validations" do
    it "should be valid" do
      @theme_asset_image.should be_valid
    end    

    it "should not be valid without a filename" do
      @theme_asset_image.filename = nil
      @theme_asset_image.should_not be_valid
    end

    it "should not be valide without a site_id" do
      @theme_asset_image.site_id = nil
      @theme_asset_image.should_not be_valid
    end
  end

  # -- associations ---
  describe "associations" do
    it "should belong to a theme_collection" do
      @theme_asset_image.should belong_to(:theme_collection)
    end
  end

  # -- instance methods --
  describe "instance methods" do
    describe "#asset" do
      it "should return the asset" do
        @theme_asset_image.asset.should be_kind_of(Sprockets::StaticAsset)
      end
    end    
  end

   # -- Scopes ---
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
         other.last.should == @theme_asset_other
       end
     end
   end
end
