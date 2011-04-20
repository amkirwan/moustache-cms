require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Site do   
  before(:each) do
    @site = Factory(:site)
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
      @site.should reference_many(:pages)
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
  end
end




