require 'spec_helper'

describe Site do   
  
  before(:each) do
    @site = Factory(:site)  
    @user = Factory(:user, :site => @site)    
    @layout = Factory(:layout, :site => @site, :created_by => @user, :updated_by => @user) 
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
      Factory.build(:site, :name => @site.name).should_not be_valid
    end
    
    it "should not be valid without a subdomain" do
      @site.subdomain = nil
      @site.should_not be_valid
    end    
    
    it "should not be valid with a duplicate hostname" do
      Factory.build(:site, :subdomain => @site.subdomain).should_not be_valid
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
    
    it "should have many theme_assets" do
      @site.should have_many(:theme_assets).with_dependent(:destroy)
    end

    it "should have many snippets" do
      @site.should have_many(:snippets).with_dependent(:destroy)
    end

    it "should embed many meta_tags" do
      @site.should embed_many :meta_tags
    end

    it "should have many authors" do
      @site.should have_many(:authors).with_dependent(:destroy)
    end

    it "should have many articles" do
      @site.should have_many(:articles).with_dependent(:destroy)
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
    
    describe "#add_subdomain_to_domain_names" do
      it "should add the new subdomain and delete the old one" do
        @site.subdomain = "baz"
        @site.default_domain = "chicago-cubs.com"
        @site.save
        @site.full_subdomain.should == "baz.chicago-cubs.com"
        @site.domain_names.should have(1).item
      end
    end
    
    describe "#add_domain" do
      it "should add an additional domain_names" do
        @site.add_full_subdomain("baz.chicago-cubs.com")
        @site.save
        @site.domain_names.should have(2).items
      end
    end
    
    describe "#page_by_title" do
      it "should return the page by the title" do   
        @site.pages << page = Factory(:page, :title => "foobar", :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user)
        @site.page_by_title(page.title).should == page
      end
    end
    
    describe "#page_by_full_path" do
      it "should return the page" do    
        @site.pages << page = Factory(:page, :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user)
        @site.page_by_full_path(page.full_path).should == page
      end
    end
    
    describe "#css_files" do
      it "should return all the css files for the site" do
        theme_asset_csses = [Factory(:theme_asset, :site => @site, :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css")]
        @site.css_files.should == theme_asset_csses
      end
    end
    
    describe "#css_file_by_name(name)" do
      it "should return the css file by the given name" do
        theme_asset_css = Factory(:theme_asset, :name => "foobar", :site => @site, :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css")
        @site.css_file_by_name("foobar").should == theme_asset_css
      end
    end   
    
    describe "#snippets_by_name(name)" do
      it "should return the snippet by the given name" do
        snippet = Factory(:snippet, :name => "foobar", :site_id => @site.id)    
        @site.snippet_by_name("foobar").should == snippet
      end
    end
  end
end




