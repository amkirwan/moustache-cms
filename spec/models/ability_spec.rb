require 'spec_helper'
require "cancan/matchers"

describe Ability do
  let(:site) { FactoryGirl.create(:site) }
  let(:other_site) { FactoryGirl.create(:site) }

  let(:admin) { FactoryGirl.build(:admin, :site => site) }
  let(:admin_other_site) { FactoryGirl.build(:admin, :site => other_site) }
  let(:designer) { FactoryGirl.build(:designer, :site => site) }
  let(:editor) { FactoryGirl.build(:editor, :site => site) }

  let(:admin_ability) { Ability.new(admin) }
  let(:admin_ability_other_site) { Ability.new(admin_other_site) }
  let(:designer_ability) { Ability.new(designer) }
  let(:editor_ability) { Ability.new(editor) }

  let(:layout) { FactoryGirl.build(:layout, :site => site) }
  let(:layout_other_site) { FactoryGirl.build(:layout, :site => other_site) }

  let(:meta_tag) { FactoryGirl.build(:meta_tag) }
  let(:meta_tag_other_site) { FactoryGirl.build(:meta_tag) }

  let(:page_part) { FactoryGirl.build(:page_part) }
  let(:page_part_other_site) { FactoryGirl.build(:page_part) }
  
  let(:page) { FactoryGirl.build(:page, :site => site, :page_parts => [page_part], :editors => [ admin, designer, editor ], :meta_tags => [meta_tag]) }
  let(:page_other_site) { FactoryGirl.build(:page, :site => other_site, :page_parts => [page_part_other_site], :editors => [ admin_other_site ], :meta_tags => [meta_tag_other_site]) } 

  let(:author) { FactoryGirl.build(:author, :site => site) }
  let(:author_other_site) { FactoryGirl.build(:author, :site => other_site) } 

  let(:article_collection) { FactoryGirl.create(:article_collection, :site => site, :articles => [], :editors => [admin, designer, editor]) }
  let(:article_collection_other_site) { FactoryGirl.create(:article_collection, :site => other_site, :articles => [], :editors => [admin_other_site]) }

  let(:article) { FactoryGirl.create(:article, :site => site, :article_collection => article_collection) } 
  let(:article_other_site) { FactoryGirl.create(:article, :site => other_site, :article_collection => article_collection_other_site) } 

  let(:site_asset) { FactoryGirl.build(:site_asset, :creator_id => editor.id, :updator_id => editor.id) }
  let(:site_asset_other_site) { FactoryGirl.build(:site_asset, :creator_id => editor.id, :updator_id => editor.id) }
  
  let(:asset_collection) { FactoryGirl.build(:asset_collection, :site => site, :created_by => admin, :site_assets => [site_asset]) }
  let(:asset_collection_other_site) { FactoryGirl.build(:asset_collection, :site => other_site, :created_by => admin, :site_assets => [site_asset_other_site]) }

  let(:snippet) { FactoryGirl.build(:snippet, :site => site) }
  let(:snippet_other_site) { FactoryGirl.build(:snippet, :site => other_site) }

  let(:theme_asset) { FactoryGirl.build(:theme_asset, :creator_id => admin.id, :updator_id => admin.id) }
  let(:theme_asset_other_site) { FactoryGirl.build(:theme_asset, :creator_id => admin_other_site.id, :updator_id => admin_other_site.id) }

  let(:theme_collection) { FactoryGirl.build(:theme_collection, :site => site, :created_by => admin, :theme_assets => [theme_asset]) }

  let(:theme_collection_other_site) { FactoryGirl.build(:theme_collection, :site => other_site, :created_by => admin, :theme_assets => [theme_asset_other_site]) }

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
          editor_ability.should be_able_to(:manage, article)
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
          editor_ability.should be_able_to(:manage, page.meta_tags.first)
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
          editor_ability.should_not be_able_to(:new, FactoryGirl.build(:user))
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
          editor_ability.should_not be_able_to(:create, FactoryGirl.create(:page, :site => site))
        end

        it "should not allow the user with a role of editor to read a page they are not an editor for" do
          editor_ability.should_not be_able_to(:read, FactoryGirl.build(:page))
        end

        it "should not allow the user with a role of editor to update a page they are not an editor for" do
          editor_ability.should_not be_able_to(:update, FactoryGirl.build(:page))
        end

        it "should not allow the user with a role of editor to destroy pages they are not an editor for" do
          editor_ability.should_not be_able_to(:destroy, FactoryGirl.build(:page))
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

      describe "Article Not Approved" do
        it "should not allow the user with a role of editor to manage articles if they are not an editor of the collection" do
          collection = FactoryGirl.build(:article_collection, :site => site, :editors => [], :articles => [article]) 
          editor_ability.should_not be_able_to(:manage, collection.articles.first)
        end
      end
      
      describe "AssetCollection Not Approved" do
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
        it "should not allow the editor to manage the theme_collection" do
          editor_ability.should_not be_able_to(:manage, theme_collection)
        end  
      end

      describe "MetaTags Model Not Approved" do
        it "should not allow the editor to manage the sites meta_tags" do
          editor_ability.should_not be_able_to(:manage, site.meta_tags.first)
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

      describe "Designer ThemeAsset Model Approved" do
        it "should allow the user with the role of designer to manage the sites theme_collection" do
          designer_ability.should be_able_to(:manage, theme_collection)
        end
      end

      describe "Designer Snippet Model Approved" do
        it "should allow the user with the role of designer to manage the sites snippets" do
          designer_ability.should be_able_to(:manage, snippet)
        end
      end

      describe "Designer Author Approved" do
        it "should allow the user with the role of designer to manage the authors" do
          designer_ability.should be_able_to(:manage, author)
        end
      end
    end
  end

  describe "Admin" do
  # -- Admin Approved Actions ----
    context "Admin Approved" do
      describe "Admin Site Model Approved" do
        it "should allow the user with the role of admin to manager the site" do
          admin_ability.should be_able_to(:read, site)
          admin_ability.should be_able_to(:update, site)
          admin_ability.should be_able_to(:destroy, site)
          admin_ability.should be_able_to(:create, Site.new)
        end
      end

      describe "Admin Page Model Approved" do
        it "should allow the user with the role of admin to manage the sites pages" do
          admin_ability.should be_able_to(:manage, page)
        end
      end

      describe "Admin AssetCollection Model Approved" do
        it "should allow the user with the role of admin to manage the sites asset_collection" do
          admin_ability.should be_able_to(:manage, asset_collection)
        end
      end

      describe "Admin Article Model approved" do
        it "should allow the user with the role of admin to manage the sites articles" do
          admin_ability.should be_able_to(:manage, article)
        end
      end

      describe "Admin ArticleCollection Approved" do
        it "should allow the user with the role of admin to manage the article_collections" do
          admin_ability.should be_able_to(:manage, article_collection)
        end
      end

      describe "Admin ThemeCollection Approved" do
        it "should allow the user with the role of admin to manage the theme_collections" do
          admin_ability.should be_able_to(:manage, theme_collection)
        end
      end

      describe "Admin User Model Approved" do
        it "should allow the user with the role of admin to manager the user accounts for the site" do
          admin_ability.should be_able_to(:manager, editor)
        end
      end

      describe "Admin MetaTag Approved" do
        it "should allow the user with the role of admin to manage the sites meta tags" do
          admin_ability.should be_able_to(:manager, site.meta_tags.first)
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
      admin_ability.should_not be_able_to(:manage, theme_collection_other_site)
      admin_ability.should_not be_able_to(:manage, asset_collection_other_site)

      admin_ability.should_not be_able_to(:read, asset_collection_other_site.site_assets.first)

      admin_ability.should_not be_able_to(:manage, page_other_site.meta_tags.first)

      admin_ability.should_not be_able_to(:manage, page_other_site.page_parts.first)

      admin_ability.should_not be_able_to(:read, article_collection_other_site)

      admin_ability.should_not be_able_to(:manage, article_other_site)

      admin_ability.should_not be_able_to(:change_password, admin_other_site)
      admin_ability.should_not be_able_to(:manage, admin_other_site)
    end
  end
end
