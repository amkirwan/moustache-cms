require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../lib/etherweb/mongoid/meta_data_shared_examples') 

describe Site do   
  before(:each) do
    @site = Factory(:site)
  end
  
  # -- Assignment -------------------------------------------
  describe "mass assignment" do
    it "should protect against mass assignment of default_domain and domains field" do
      site = Site.new(:default_domain => "example.com", :domains => ["foobar.example.com"] )
      site.default_domain.should be_nil
      site.domains.should be_empty
    end
    
    
    it "should allow mass assignment of" do
      page = Site.new(:name => "foobar", :subdomain => "foobar", :meta_data => { "title" => "foobar"})
      page.name.should == "foobar"
      page.subdomain.should == "foobar" 
      page.meta_data.should_not == nil
    end
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
    it "should have many pages" do
      @site.should have_many(:pages)
    end 
    
    it "should reference many site_assets" do
      @site.should have_many(:site_assets).of_type(SiteAsset)
    end 
    
    it "should have many layouts" do
      @site.should have_many(:layouts)
    end
    
    it "should have many users" do
      @site.should have_many(:users)
    end
    
    it "should have many theme_assets" do
      @site.should have_many(:theme_assets).of_type(ThemeAsset)
    end
  end
  
  
  # -- Scope ------------------------------------------------------
  describe "#match_domain" do
    it "should return a site when the domain exists" do
      sites = Site.match_domain("#{@site.subdomain}.example.com")
      sites.size.should == 1
      sites.first.should == @site
    end
    
    it "should return empty Criteria if it cannot find the domain" do
      sites = Site.match_domain("unknown.com")
      sites.should be_empty
      sites.first.should be_nil     
    end
  end
  
  # -- Check :dependent => :delete ------------------------------------------- 
  describe ":dependent => :delete" do
    before(:each) do
      @user = Factory(:user, :site => @site)
      @layout = Factory(:layout, :site => @site, :created_by => @user, :updated_by => @user)
      @page = Factory(:page, :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user, :editor_ids => [@user.id])
      @site_asset = Factory(:site_asset, :site => @site, :created_by => @user, :updated_by => @user) 
    end
    
    describe "#destroy_pages" do
      it "should destroy all the pages associated with the site" do
        @site.pages.count.should == 1
        @site.destroy
        @site.pages.count.should == 0
      end
    end
    
    describe "#destroy_users" do
      it "should destroy all the users associated with the site" do
        @site.users.count.should == 1
        @site.destroy
        @site.users.count.should == 0
      end
    end
    
    describe "#destroy_layouts" do
      it "should destroy all the layouts associated with the site" do
        @site.layouts.count.should == 1
        @site.destroy
        @site.layouts.count.should == 0
      end
    end
    
    describe "#destroy_site_assets" do
      it "should destroy all the site_assets associated with the site" do
        @site.site_assets.count.should == 1
        @site.destroy
        @site.site_assets.count.should == 0
      end
    end
  end


  # -- Instance Methods ------------------------------------------------------
  describe "instance methods" do
    describe "#full_subdomain" do
      it "should return the full domain" do
        @site.full_subdomain.should == "#{@site.subdomain}.example.com"
      end
    end
    
    describe "#add_subdomain_to_domains" do
      it "should add the new subdomain and domain and delete the old one" do
        @site.subdomain = "baz"
        @site.default_domain = "chicago-cubs.com"
        @site.save
        @site.full_subdomain.should == "baz.chicago-cubs.com"
        @site.domains.should have(1).item
      end
    end
    
    describe "#add_domain" do
      it "should add an additional domains" do
        @site.add_full_subdomain("baz.chicago-cubs.com")
        @site.save
        @site.domains.should have(2).items
      end
    end
  end
end




