require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')  
require "cancan/matchers"

describe Ability do  
  let(:site) { Factory.build(:site) }
  let(:site2) { Factory.build(:site) }
  
  let(:admin) { Factory.build(:admin, :site => site) }
  let(:admin2) { Factory.build(:admin, :site => site2) }
  let(:designer) { Factory.build(:designer, :site => site) }
  let(:designer2) { Factory.build(:designer, :site => site2) }
  let(:editor) { Factory.build(:editor, :site => site) }
  let(:editor2) { Factory.build(:editor, :site => site2) }
  
  let(:layout) { Factory.build(:layout, :site => site) }
  let(:layout2) { Factory.build(:layout, :site => site2) }

  let(:meta_tag) { Factory.build(:meta_tag) }
  let(:meta_tag2) { Factory.build(:meta_tag) }

  let(:page_part) { Factory.build(:page_part) }
  let(:page_part2) { Factory.build(:page_part) }
  
  let(:page) { Factory.build(:page, :site => site, :page_parts => [page_part], :editors => [ admin, designer, editor ], :meta_tags => [meta_tag]) }
  let(:page2) { Factory.build(:page, :site => site2, :page_parts => [page_part2], :editors => [ admin2, designer2, editor2 ], :meta_tags => [meta_tag2]) } 
  
  let(:site_asset) { Factory.build(:site_asset, :creator_id => editor.id, :updator_id => editor.id) }
  let(:site_asset2) { Factory.build(:site_asset, :creator_id => editor.id, :updator_id => editor.id) }
  
  let(:asset_collection) { Factory.build(:asset_collection, :site => site, :created_by => admin, :site_assets => [site_asset]) }
  let(:asset_collection2) { Factory.build(:asset_collection, :site => site2, :created_by => admin, :site_assets => [site_asset2]) }
  
  let(:tag_attr) { Factory.build(:tag_attr) }
  let(:tag_attr2) { Factory.build(:tag_attr) }

  let(:theme_asset) { Factory.build(:theme_asset, :site => site, :created_by => admin, :tag_attrs => [tag_attr]) }
  let(:theme_asset2) { Factory.build(:theme_asset, :site => site2, :created_by => admin2, :tag_attrs => [tag_attr2]) }

  
  let(:admin_ability) { Ability.new(admin) }
  let(:admin_ability2) { Ability.new(admin2) }
  let(:designer_ability) { Ability.new(designer) }
  let(:designer_ability2) { Ability.new(designer2) }
  let(:editor_ability) { Ability.new(editor) }
  let(:editor_ability2) { Ability.new(editor2) }
  let(:user) { Factory.build(:user, :site => site) } 
  
  before(:each) do
    site.users << admin
    site2.users << admin2
  end
  
  after(:each) do
    site.users = []
    site2.users = []
  end
  
  def site_asset_first
    asset_collection.site_assets.first
  end

  def meta_tag_first
    page.meta_tags.first
  end

  def page_part_first
    page.page_parts.first
  end
  
  # -- Admin ----
  describe "Admin" do
    context "Admin Approved" do
      it "should allow the admin to manage all" do 
        admin_ability.should be_able_to(:manage, site)
        admin_ability.should be_able_to(:manage, admin)
        admin_ability.should be_able_to(:manage, page)
        admin_ability.should be_able_to(:manage, layout)
        admin_ability.should be_able_to(:manage, theme_asset)
        admin_ability.should be_able_to(:manage, asset_collection)
        
        admin_ability.should be_able_to(:read, site_asset_first)
        admin_ability.should be_able_to(:create, site_asset_first)
        admin_ability.should be_able_to(:update, site_asset_first)
        admin_ability.should be_able_to(:destroy, site_asset_first)

        admin_ability.should be_able_to(:read, meta_tag_first)
        admin_ability.should be_able_to(:create, meta_tag_first)
        admin_ability.should be_able_to(:update, meta_tag_first)
        admin_ability.should be_able_to(:destroy, meta_tag_first)

        
        admin_ability.should be_able_to(:read, page_part_first)
        admin_ability.should be_able_to(:create, page_part_first)
        admin_ability.should be_able_to(:update, page_part_first)
        admin_ability.should be_able_to(:destroy, page_part_first)

        admin_ability.should be_able_to(:change_password, admin)
      end
    end
    
    context "Admin Not Approved" do
      describe "should not be able to manage any item that does not have an associated site as the admin" do
        it "should not allow the admin to manage sites they are not associatied with" do
          admin_ability.should_not be_able_to(:manage, site2)
          admin_ability.should_not be_able_to(:manage, admin2)
          admin_ability.should_not be_able_to(:manage, editor2)
          admin_ability.should_not be_able_to(:manage, page2)
          admin_ability.should_not be_able_to(:manage, layout2)
          admin_ability.should_not be_able_to(:manage, theme_asset2)
          admin_ability.should_not be_able_to(:manage, asset_collection2)
          
          admin_ability.should_not be_able_to(:read, asset_collection2.site_assets.first)
          admin_ability.should_not be_able_to(:update, asset_collection2.site_assets.first)
          admin_ability.should_not be_able_to(:destroy, asset_collection2.site_assets.first)

          admin_ability.should_not be_able_to(:read, page2.meta_tags.first)
          admin_ability.should_not be_able_to(:update, page2.meta_tags.first)
          admin_ability.should_not be_able_to(:destroy, page2.meta_tags.first)

          admin_ability.should_not be_able_to(:read, page2.page_parts.first)
          admin_ability.should_not be_able_to(:update, page2.page_parts.first)
          admin_ability.should_not be_able_to(:destroy, page2.page_parts.first)


          admin_ability.should_not be_able_to(:change_password, admin2)
        end
      end      
    end
  end
  
  # -- Designer Approved ----
  describe "Designer" do
    context "Designer Approved" do
      describe "User Model Approved" do
        it "should allow the user with a role of designer to list user records" do
          designer_ability.should be_able_to(:index, user)
        end  
      
        it "should allow the user with a role of designer to edit their own record" do
          designer_ability.should be_able_to(:update, designer)
        end
      
        it "should allow the user with a role of designer to show their own record" do
          designer_ability.should be_able_to(:show, designer)
        end
        
        it "should allow the user with a role of designer to delete their record" do
          designer_ability.should be_able_to(:destroy, designer)
        end

        it "should allow the user to change their own password" do
          designer_ability.should be_able_to(:change_password, designer)
        end
      end
      
      describe "Models user with role of designer can manage" do
        it "should allow the designer to edit all pages, layouts, asset_collection, site_assets and theme_assets" do
          designer_ability.should be_able_to(:manage, page)
          designer_ability.should be_able_to(:manage, layout)
          designer_ability.should be_able_to(:manage, theme_asset)
          designer_ability.should be_able_to(:manage, asset_collection)
          
          designer_ability.should be_able_to(:read, site_asset_first)
          designer_ability.should be_able_to(:create, site_asset_first)
          designer_ability.should be_able_to(:update, site_asset_first)
          designer_ability.should be_able_to(:destroy, site_asset_first)  

          designer_ability.should be_able_to(:read, meta_tag_first)
          designer_ability.should be_able_to(:create, meta_tag_first)
          designer_ability.should be_able_to(:update, meta_tag_first)
          designer_ability.should be_able_to(:destroy, meta_tag_first)
        end
      end

      describe "should not be able to manage any item that does not have an associated site as the designer" do
        it "should not allow the designer to  change other users passwords" do
          designer_ability.should_not be_able_to(:change_password, designer2)
        end
        it "should not allow the designer to manage sites they are not associatied with" do
          designer_ability.should_not be_able_to(:read, page2.page_parts.first)
          designer_ability.should_not be_able_to(:update, page2.page_parts.first)
          designer_ability.should_not be_able_to(:destroy, page2.page_parts.first)
        end
      end

    end
  end
  
  # -- Editor Approved ----
  describe "Editor" do
    context "Editor Approved" do
        describe "User Model Approved" do
          it "should allow the user with a role of editor to list editor records" do
            editor_ability.should be_able_to(:index, user)
          end

          it "should allow the user with a role of editor to edit their own record" do
            editor_ability.should be_able_to(:update, editor)
          end  

          it "should allow the user with a role of editor to show their own record" do
            editor_ability.should be_able_to(:show, editor)
          end
          
          it "should allow the user with a role of editor to delete their record" do
            editor_ability.should be_able_to(:destroy, editor)
          end

          it "should allow the user to change their own password" do
          designer_ability.should be_able_to(:change_password, designer)
          end
        end

        describe "Page Approved" do
          it "should allow the user with a role of editor to create pages" do
            editor_ability.should be_able_to(:create, page)
          end

          it "should allow the user with a role of editor to index action" do
            editor_ability.should be_able_to(:index, page)
          end

          it "should allow the user with a role of editor to show pages they are an editor for" do
            editor_ability.should be_able_to(:show, page)
          end

          it "should allow the user with a role of editor to update pages they have editor rights for" do
            editor_ability.should be_able_to(:update, page)
          end

          it "should allow the user with a role of editor to destroy pages they have editor rights for" do
            editor_ability.should be_able_to(:destroy, page)
          end      
        end
        
        describe "AssetCollection Approved" do
          it "should allow the user with a role of editor to read(:index, :show) asset_collection" do
            editor_ability.should be_able_to(:read, asset_collection)
          end
        end

        describe "SiteAsset Approved" do

          it "should allow the user with a role of editor to manage the site_assets" do
            editor_ability.should be_able_to(:read, site_asset_first)
            editor_ability.should be_able_to(:create, site_asset_first)
            editor_ability.should be_able_to(:update, site_asset_first)
            editor_ability.should be_able_to(:destroy, site_asset_first)
          end
        end

        describe "MetaTags Approved" do
          it "should allow the user with a role of editor to manage the pages meta_tags" do 
            editor_ability.should be_able_to(:read, meta_tag_first)
            editor_ability.should be_able_to(:create, meta_tag_first)
            editor_ability.should be_able_to(:update, meta_tag_first)
            editor_ability.should be_able_to(:destroy, meta_tag_first)
          end
        end

        describe "PageParts Approved" do
          it "should allow the user with a role of editor to manage the pages meta_tags" do 
            editor_ability.should be_able_to(:read, page_part_first)
            editor_ability.should be_able_to(:create, page_part_first)
            editor_ability.should be_able_to(:update, page_part_first)
            editor_ability.should be_able_to(:destroy, page_part_first)
          end
        end

      end
    end
    
    # -- Editor Not Approved ----
    context "Editor Not Approved Actions" do    
      describe "Site Model" do
        it "should not allow a the user as an editor to manage sites" do
          editor_ability.should_not be_able_to(:manage, site)
        end

        it "should not allow the editor to manage sites they are not associatied with" do
          editor_ability.should_not be_able_to(:manage, layout2)
        end
      end

      describe "editor Model Not Approved" do
        it "should not allow the user with a role of editor to read other users records" do
          editor_ability.should_not be_able_to(:read, user)
        end

        it "should not allow the user with a role of editor to create a new user record" do
          editor_ability.should_not be_able_to(:new, Factory.build(:user))
        end

        it "should not allow the user with a role of editor to edit other user records" do
          editor_ability.should_not be_able_to(:update, user)
        end    

        it "should not allow the editor to manage users on another site" do
          editor_ability.should_not be_able_to(:read, editor2)
          editor_ability.should_not be_able_to(:create, editor2)
          editor_ability.should_not be_able_to(:update, editor2)
          editor_ability.should_not be_able_to(:destroy, editor2)
          editor_ability.should_not be_able_to(:change_password, editor2)
        end
      end

      describe "Layout Model Not Approved" do
        it "should not allow the editor to mange layouts" do
          editor_ability.should_not be_able_to(:read, layout)
          editor_ability.should_not be_able_to(:create, layout)
          editor_ability.should_not be_able_to(:update, layout)
          editor_ability.should_not be_able_to(:destroy, layout)
        end
      end

      describe "Page Model Not Approved" do
        it "should not allow the user with a role of editor to read a page they are not an editor for" do
          editor_ability.should_not be_able_to(:read, Factory.build(:page))
        end

        it "should not allow the user with a role of editor to update a page they are not an editor for" do
          editor_ability.should_not be_able_to(:update, Factory.build(:page))
        end

        it "should not allow the user with a role of editor to destroy pages they are not an editor for" do
          editor_ability.should_not be_able_to(:destroy, Factory.build(:page))
        end

        it "should not allow the editor to manage pages on another site" do 
          editor_ability.should_not be_able_to(:read, page2)
          editor_ability.should_not be_able_to(:create, page2)
          editor_ability.should_not be_able_to(:update, page2)
          editor_ability.should_not be_able_to(:destroy, page2)
        end
      end
      
      describe "AssetCollection Approved" do
        it "should not allow the user with a role of editor to create asset_collections" do
          editor_ability.should_not be_able_to(:create, asset_collection)
        end
        
        it "should not allow the user with a role of editor to update asset_collections" do
          editor_ability.should_not be_able_to(:update, asset_collection)
        end
        
        it "should not allow the user with a role of editor to delte asset_collections" do
          editor_ability.should_not be_able_to(:destroy, asset_collection)
        end
        
        it "should not allow the editor to manage the asset_collections on another site" do
          editor_ability.should_not be_able_to(:read, asset_collection2)
          editor_ability.should_not be_able_to(:create, asset_collection2)
          editor_ability.should_not be_able_to(:update, asset_collection2)
          editor_ability.should_not be_able_to(:destroy, asset_collection2)
        end
      end

      describe "SiteAsset Model Not Approved" do        
        it "should not allow the editor to manage site_assets on another site" do
          editor_ability.should_not be_able_to(:read, asset_collection2.site_assets.first)
          editor_ability.should_not be_able_to(:update, asset_collection2.site_assets.first)
          editor_ability.should_not be_able_to(:destroy, asset_collection2.site_assets.first)
        end
      end
      
      describe "ThemeAsset Model Not Approved" do
        it "should not allow the editor to manage the theme_assets" do
          editor_ability.should_not be_able_to(:read, theme_asset)
          editor_ability.should_not be_able_to(:create, theme_asset)
          editor_ability.should_not be_able_to(:update, theme_asset)
          editor_ability.should_not be_able_to(:destroy, theme_asset)
        end  
        
        it "should not allow the editor to manage theme_assets on another site" do
          editor_ability.should_not be_able_to(:read, theme_asset2)
          editor_ability.should_not be_able_to(:create, theme_asset2)
          editor_ability.should_not be_able_to(:update, theme_asset2)
          editor_ability.should_not be_able_to(:destroy, theme_asset2)
        end   
      end
  end   
end
