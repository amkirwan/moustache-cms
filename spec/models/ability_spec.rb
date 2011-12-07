require 'spec_helper'
require "cancan/matchers"

describe Ability do
  let(:site) { Factory(:site) }
  let(:other_site) { Factory(:site) }

  let(:admin) { Factory.build(:admin, :site => site) }
  let(:admin_other_site) { Factory.build(:admin, :site => other_site) }
  let(:designer) { Factory.build(:designer, :site => site) }
  let(:editor) { Factory.build(:editor, :site => site) }

  let(:admin_ability) { Ability.new(admin) }
  let(:admin_ability_other_site) { Ability.new(admin_other_site) }
  let(:designer_ability) { Ability.new(designer) }
  let(:editor_ability) { Ability.new(editor) }

  let(:layout) { Factory.build(:layout, :site => site) }
  let(:layout_other_site) { Factory.build(:layout, :site => other_site) }

  let(:meta_tag) { Factory.build(:meta_tag) }
  let(:meta_tag_other_site) { Factory.build(:meta_tag) }

  let(:page_part) { Factory.build(:page_part) }
  let(:page_part_other_site) { Factory.build(:page_part) }
  
  let(:page) { Factory.build(:page, :site => site, :page_parts => [page_part], :editors => [ admin, designer, editor ], :meta_tags => [meta_tag]) }
  let(:page_other_site) { Factory.build(:page, :site => other_site, :page_parts => [page_part_other_site], :editors => [ admin_other_site ], :meta_tags => [meta_tag_other_site]) } 

  let(:article) { Factory.build(:article, :site => site) } 
  let(:article_other_site) { Factory.build(:article, :site => other_site) } 
  
  let(:article_collection) { Factory.build(:article_collection, :site => site, :editors => [admin, designer, editor], :articles => [article]) }
  let(:article_collection_other_site) { Factory.build(:article_collection, :site => other_site, :editors => [admin_other_site], :articles => [article_other_site]) }

  let(:site_asset) { Factory.build(:site_asset, :creator_id => editor.id, :updator_id => editor.id) }
  let(:site_asset_other_site) { Factory.build(:site_asset, :creator_id => editor.id, :updator_id => editor.id) }
  
  let(:asset_collection) { Factory.build(:asset_collection, :site => site, :created_by => admin, :site_assets => [site_asset]) }
  let(:asset_collection_other_site) { Factory.build(:asset_collection, :site => other_site, :created_by => admin, :site_assets => [site_asset_other_site]) }

  let(:snippet) { Factory.build(:snippet, :site => site) }
  let(:snippet_other_site) { Factory.build(:snippet, :site => other_site) }

  let(:tag_attr) { Factory.build(:tag_attr) }
  let(:tag_attr_other_site) { Factory.build(:tag_attr) }

  let(:theme_asset) { Factory.build(:theme_asset, :site => site, :created_by => admin, :tag_attrs => [tag_attr]) }
  let(:theme_asset_other_site) { Factory.build(:theme_asset, :site => other_site, :created_by => admin_other_site, :tag_attrs => [tag_attr_other_site]) }

  def site_asset_first
    asset_collection.site_assets.first
  end

  def meta_tag_first
    page.meta_tags.first
  end

  def page_part_first
    page.page_parts.first
  end

  def article_first
    article_collection.articles.first
  end
  

  describe "Editor" do
    # -- Editor Approved Actions ----
    context "Editor Approved" do
      describe "Editor User Model Approved" do
        it "should allow the editor to list all accounts" do
          editor_ability.should be_able_to(:read, admin)
        end

        it "should allow the editor to update their account" do
          editor_ability.should be_able_to(:update, editor)
        end

        it "should allow the editor to destroy their account" do
          editor_ability.should be_able_to(:destroy, editor)
        end

        it "should allow the editor to change their password" do
          editor_ability.should be_able_to(:change_password, editor)
        end
      end


      describe "Page Approved" do
        it "should allow the user with a role of editor to read pages" do
          editor_ability.should be_able_to(:read, page)
        end

        it "should allow the user with a role of editor to update pages they have editor rights for" do
          editor_ability.should be_able_to(:update, page)
        end

        it "should allow the user with a role of editor to destroy pages they have editor rights for" do
          editor_ability.should be_able_to(:destroy, page)
        end      
      end

      describe "ArticleCollection Approved" do
        it "should allow the user with a role of editor to read article_collection" do
          editor_ability.should be_able_to(:read, article_collection)
        end
      end

      describe "Article Approved" do
        it "should allow the user with a role of editor to manage articles if they are editors of the collection" do
          editor_ability.should be_able_to(:manage, article_first)
        end
      end

      describe "Article Approved" do
        it "should allow the user with a role of editor to manage the articles that they are an editor for" do

          editor_ability.should be_able_to(:manage, site_asset_first)
        end
      end

      describe "AssetCollection Approved" do
        it "should allow the user with a role of editor to read asset_collection" do
          editor_ability.should be_able_to(:read, asset_collection)
        end
      end

      describe "SiteAsset Approved" do
        it "should allow the user with a role of editor to manage the site_assets" do
          editor_ability.should be_able_to(:manage, site_asset_first)
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
          editor_ability.should be_able_to(:manage, page_part_first)
        end
      end
    end

    # -- Editor NOT Approved Actions ----
    context "Editor Not Approved Actions" do    
      describe "Site Model" do
        it "should not allow a the user as an editor to manage sites" do
          editor_ability.should_not be_able_to(:manage, site)
        end
      end

      describe "User Model Not Approved" do
        it "should not allow the user with a role of editor to create a new user record" do
          editor_ability.should_not be_able_to(:new, Factory.build(:user))
        end

        it "should not allow the user with a role of editor to edit another user records" do
          editor_ability.should_not be_able_to(:update, admin)
        end    

        it "should not allow the user with a role of editor to change another usrs password" do
          editor_ability.should_not be_able_to(:change_password, admin)
        end
      end

      describe "Layout Model Not Approved" do
        it "should not allow the editor to mange layouts" do
          editor_ability.should_not be_able_to(:manage, layout)
        end
      end

      describe "Page Model Not Approved" do
        it "should not allow the user with a role of editor to create pages" do
          editor_ability.should_not be_able_to(:create, Factory(:page, :site => site))
        end

        it "should not allow the user with a role of editor to read a page they are not an editor for" do
          editor_ability.should_not be_able_to(:read, Factory.build(:page))
        end

        it "should not allow the user with a role of editor to update a page they are not an editor for" do
          editor_ability.should_not be_able_to(:update, Factory.build(:page))
        end

        it "should not allow the user with a role of editor to destroy pages they are not an editor for" do
          editor_ability.should_not be_able_to(:destroy, Factory.build(:page))
        end
      end
      
      describe "ArticleCollection Not Approved" do
        it "should not allow the user with a role of editor to create article_collections" do
          editor_ability.should_not be_able_to(:create, article_collection)
        end
        
        it "should not allow the user with a role of editor to update article_collections" do
          editor_ability.should_not be_able_to(:update, article_collection)
        end
        
        it "should not allow the user with a role of editor to delte article_collections" do
          editor_ability.should_not be_able_to(:destroy, article_collection)
        end
      end

      describe "Article Approved" do
        it "should not allow the user with a role of editor to manage articles if they are not an editor of the collection" do
          collection = Factory.build(:article_collection, :site => site, :editors => [], :articles => [article]) 
          editor_ability.should_not be_able_to(:manage, collection.articles.first)
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
      end

      describe "ThemeAsset Model Not Approved" do
        it "should not allow the editor to manage the theme_assets" do
          editor_ability.should_not be_able_to(:manage, theme_asset)
        end  
      end
    end
  end

  describe "Designer" do
  # -- Designer Approved Actions ----
    context "Designer Approved" do
      describe "Designer Layout Model Approved" do
        it "should allow the user with the role of designer to manage the sites layouts" do
          designer_ability.should be_able_to(:manage, layout)
        end
      end

      describe "Designer Page Model Approved" do
        it "should allow the user with the role of designer to manage the sites pages" do
          designer_ability.should be_able_to(:manage, page)
        end
      end

      describe "Designer AssetCollection Model Approved" do
        it "should allow the user with the role of designer to manage the sites asset_collection" do
          designer_ability.should be_able_to(:manage, asset_collection)
        end
      end

      describe "Designer ThemeAsset Model Approved" do
        it "should allow the user with the role of designer to manage the sites theme_assets" do
          designer_ability.should be_able_to(:manage, theme_asset)
        end
      end

      describe "Designer Snippet Model Approved" do
        it "should allow the user with the role of designer to manage the sites snippets" do
          designer_ability.should be_able_to(:manage, snippet)
        end
      end

      describe "Designer ArticleCollection Approved" do
        it "should allow the user with the role of designer to manage the article_collections" do
          designer_ability.should be_able_to(:manage, article_collection)
        end
      end

    end
  end

  describe "Admin" do
  # -- Admin Approved Actions ----
    context "Admin Approved" do
      describe "Admin Site Model Approved" do
        it "should allow the user with the role of admin to manager the site" do
          admin_ability.should be_able_to(:manager, site)
        end
      end

      describe "Admin User Model Approved" do
        it "should allow the user with the role of admin to manager the user accounts for the site" do
          admin_ability.should be_able_to(:manager, editor)
        end
      end
    end

    context "Admin NOT Approved" do
      describe "Admin User Model NOT Approved" do
        it "should not allow the user with the role of admin to change users passwords" do
          admin_ability.should_not be_able_to(:change_password, editor)
        end
      end
    end
  end


  describe "OTHER SITE" do
    it "should not allow the admin to manage other sites they are not associated with" do
      admin_ability.should_not be_able_to(:manage, other_site)
      admin_ability.should_not be_able_to(:manage, admin_other_site)
      admin_ability.should_not be_able_to(:manage, page_other_site)
      admin_ability.should_not be_able_to(:manage, layout_other_site)
      admin_ability.should_not be_able_to(:manage, theme_asset_other_site)
      admin_ability.should_not be_able_to(:manage, asset_collection_other_site)

      admin_ability.should_not be_able_to(:read, asset_collection_other_site.site_assets.first)

      admin_ability.should_not be_able_to(:manage, page_other_site.meta_tags.first)

      admin_ability.should_not be_able_to(:manage, page_other_site.page_parts.first)

      admin_ability.should_not be_able_to(:read, article_collection_other_site)
      admin_ability.should_not be_able_to(:manage, article_collection_other_site.articles.first)

      admin_ability.should_not be_able_to(:change_password, admin_other_site)
      admin_ability.should_not be_able_to(:manage, admin_other_site)
    end
  end
end
