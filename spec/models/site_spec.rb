require 'spec_helper'

describe Site do   
  
  before(:each) do
    @site = FactoryGirl.create(:site)  
    @user = FactoryGirl.create(:user, :site => @site)    
    @layout = FactoryGirl.create(:layout, :site => @site, :created_by => @user, :updated_by => @user) 
  end
  
  after(:each) do
    site_remove_assets(@site)
  end
  # -- Validations -------------------------------------------
  describe "Validations" do
    it "should be valid" do
      @site.should be_valid
    end
    
    it "should not be valid without a name" do
      @site.name = nil
      @site.should_not be_valid
    end
    
    it "should not be valid without a default_domain" do
      @site.default_domain = nil
      @site.should_not be_valid
    end
    
    it "should not be valid with a duplicate name" do
      FactoryGirl.build(:site, :name => @site.name).should_not be_valid
    end
    
    it "should not be valid without a subdomain" do
      @site.subdomain = nil
      @site.should_not be_valid
    end    
    
    it "should not be valid with a duplicate hostname" do
      FactoryGirl.build(:site, :subdomain => @site.subdomain).should_not be_valid
    end
  end
  
  # -- Associations -------------------------------------------
  describe "Associations" do
    it "should have many users" do
      @site.should have_many(:users).with_dependent(:destroy)
    end

    it "should have many pages" do
      @site.should have_many(:pages).with_dependent(:destroy)
    end 

    it "should have many layouts" do
      @site.should have_many(:layouts).with_dependent(:destroy)
    end
    
    it "should reference many asset_collections" do
      @site.should have_many(:asset_collections).with_dependent(:destroy)
    end 
    
    it "should have many snippets" do
      @site.should have_many(:snippets).with_dependent(:destroy)
    end

    it "should have many authors" do
      @site.should have_many(:authors).with_dependent(:destroy)
    end

    it "should have many article collections" do
      @site.should have_many(:article_collections).with_dependent(:destroy)
    end

    it "should have many articles" do
      @site.should have_many(:articles).with_dependent(:destroy)
    end

    it "should embed many meta_tags" do
      @site.should embed_many :meta_tags
    end

    it "should have many moustache assets" do
      @site.should have_many(:moustache_assets)
    end
  end
  
  # -- Callbacks ---
  describe "Callbacks" do
   describe "#add_subdomain_to_domain_names" do
      it "should add the new subdomain and delete the old one" do
        @site.subdomain = "baz"
        @site.default_domain = "chicago-cubs.com"
        @site.save
        @site.full_subdomain.should == "baz.chicago-cubs.com"
        @site.domain_names.should have(1).item
      end
    end
  end

  # -- Scope ------------------------------------------------------
  describe "Scope" do
    describe "#match_domain" do
      it "should return a site when the domain exists" do
        sites = Site.match_domain("#{@site.subdomain}.com")
        sites.size.should == 1
        sites.first.should == @site
      end

      it "should return empty Criteria if it cannot find the domain" do
        sites = Site.match_domain("unknown.com")
        sites.should be_empty
        sites.first.should be_nil     
      end
    end
  end
  

  # -- Instance Methods ------------------------------------------------------
  describe "instance methods" do
    describe "#full_subdomain" do
      it "should return the full domain" do
        @site.full_subdomain.should == "#{@site.subdomain}.com"
      end
    end
    
    describe "#add_domain" do
      it "should add an additional domain_names" do
        @site.add_full_subdomain("baz.chicago-cubs.com")
        @site.save
        @site.domain_names.should have(2).items
      end
    end

    describe "#find_page" do
      it "should return the page by id" do
        @site.pages << page = FactoryGirl.create(:page, :title => "foobar", :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user)
        @site.find_page(page.id).should == page  
      end
    end
    
    describe "#page_by_title" do
      it "should return the page by the title" do   
        @site.pages << page = FactoryGirl.create(:page, :title => "foobar", :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user)
        @site.page_by_title(page.title).should == page
      end
    end
    
    describe "#page_by_full_path" do
      it "should return the page" do    
        @site.pages << page = FactoryGirl.create(:page, :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user)
        @site.page_by_full_path(page.full_path).should == page
      end
    end
    
    describe "#css_files" do
      it "should return all the css files for the site" do
        theme_collection = FactoryGirl.create(:theme_collection, :site => @site)
        theme_collection.theme_assets << theme_asset_css = FactoryGirl.build(:theme_asset, :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css")
        @site.css_files.should == [theme_asset_css]
      end
    end

    describe "#css_file_by_name(theme_name, name)" do
      it "should return the css file by the given name" do
        theme_collection = FactoryGirl.create(:theme_collection, :name => 'baz', :site => @site)
        theme_collection.theme_assets << theme_asset_css = FactoryGirl.build(:theme_asset, :name => 'foobar', :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css")
        @site.css_file_by_name("baz", "foobar").should == theme_asset_css
      end
    end   

    describe "#js_file_by_name(theme_name, name)" do
      it "should return the css file by the given name" do
        theme_collection = FactoryGirl.create(:theme_collection, :name => 'baz', :site => @site)
        theme_collection.theme_assets << theme_asset_js = FactoryGirl.build(:theme_asset, :name => 'foobar', :asset => AssetFixtureHelper.open("theme_js.js"), :content_type => "application/x-javascript")
        @site.js_file_by_name("baz", "foobar").should == theme_asset_js
      end
    end   

    describe "#article_collection_by_name" do
      it "should return the article collection by the name" do
        article_collection = FactoryGirl.create(:article_collection, :site => @site, :name => "news")
        @site.article_collection_by_name('news').should == article_collection
      end
    end

    describe "#articles_by_collection_name(name)" do
      it "should return all the articles for the given article collection" do
        article_collection = FactoryGirl.create(:article_collection, :site => @site, :name => "news")
        article_collection.articles << FactoryGirl.build(:article)
        @site.articles_by_collection_name('news').should == article_collection.articles
      end
    end

    describe "#articles_by_collection_name_desc(name)" do
      it "should return all the articles for the article collection" do
        article_collection = FactoryGirl.create(:article_collection, :site => @site, :name => "news")
        article_collection.articles.unshift(FactoryGirl.build(:article))
        article_collection.articles.unshift(FactoryGirl.build(:article))
        @site.articles_by_collection_name_desc('news').to_a.should == article_collection.articles.to_a
        
      end
    end

    describe "#snippets_by_name(name)" do
      it "should return the snippet by the given name" do
        snippet = FactoryGirl.create(:snippet, :name => "foobar", :site_id => @site.id)    
        @site.snippet_by_name("foobar").should == snippet
      end
    end

    describe "#site_assets_by_name(asset_collection, file_name)" do
      it "should return the site asset by name" do
        asset_collection = FactoryGirl.create(:asset_collection, :name => 'baz', :site => @site)  
        asset_collection.site_assets << asset = FactoryGirl.build(:site_asset, :name => 'foobar')
        @site.site_asset_by_name('baz', 'foobar').should == asset
      end
    end

    describe "#meta_tag_by_name(name)" do
      it "should return the meta tag with the name" do
        meta_tag = FactoryGirl.build(:meta_tag, :name => 'foobar')
        @site.meta_tags << meta_tag
        @site.meta_tag_by_name('foobar').should == meta_tag
      end
    end

    describe "#theme_collecton_by_name(theme_name)" do
      it "should return the theme coolection with the name" do
        theme_collection = FactoryGirl.build(:theme_collection, :name => 'foobar')
        @site.theme_collections << theme_collection
        @site.theme_collection_by_name('foobar').should == theme_collection  
      end
    end

    describe "#admin_page_path" do
      it "should return the path to the admin page for the site" do
        @site.subdomain = 'foobar'
        @site.admin_page_path.should == 'foobar.com/admin'  
      end
    end

    describe "#admin_page_url" do
      it "should return the url to the admin page for the site" do
        @site.subdomain = 'foobar'
        @site.admin_page_path.should == 'foobar.com/admin'  
      end
    end

  end
end




