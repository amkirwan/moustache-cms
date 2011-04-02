require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe SiteController do
  
  # -- GET dynamic_page ----------------------------------------------- 
  describe "GET dynamic_page" do
    
    let(:page) { mock_model("Page") }
    let(:site) { mock_model("Site")}
    
    before(:each) do
      Site.stub(:load_by_hostname).and_return(site)
      Page.stub(:load_by_full_path).and_return(page)
    end
    
    def do_get
      get :render_html
    end
    
    it "should find the site for the page" do
      do_get
      assigns(:site).should == site
    end
    
    it "should find the page for the site" do
      do_get
      assigns(:page).should == site
    end
  end
end