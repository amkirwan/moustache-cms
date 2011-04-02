require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe CmsSiteController do
   
  # -- GET dynamic_page ----------------------------------------------- 
  describe "GET dynamic_page" do
    
    let(:page) { mock_model("Page") }
    let(:site) { mock_model("Site")}
    
    before(:each) do
      Site.stub(:find_by_hostname).and_return(site)
      Page.stub(:find_by_full_path).and_return(page)
    end
    
    def do_get
      get :render_html
    end
    
    context "load_site before_filter" do
      it "should find the site for the page" do
        do_get
        assigns(:site).should == site
      end
    
      it "should not find the site for the page and return 404" do
        Site.stub(:find_by_hostname).and_return(nil)
        do_get
        response.should render_template(404)
      end
    end
    
    context "load_page before_fitler" do
      it "should find the page for the site" do
        do_get
        assigns(:page).should == page
      end
      
      it "should not find the page and return 404" do
        Page.stub(:find_by_full_path).and_return(nil)
        do_get
        response.should render_template(404)
      end
    end
  end
end