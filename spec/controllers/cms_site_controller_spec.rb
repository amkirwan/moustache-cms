require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe CmsSiteController do
   
  # -- GET dynamic_page ----------------------------------------------- 
  describe "GET dynamic_page" do
    
    let(:current_site) { mock_model("Site") }
    let(:page) { mock_model("Page") }
    
    before(:each) do
      Site.stub(:match_domain).with("test.host").and_return(@criteria_sites = [current_site])
      @criteria_sites.stub(:first).and_return(current_site)
      current_site.stub_chain(:pages, :where).and_return(@criteria_pages = [page])
      @criteria_pages.stub(:first).and_return(page)
    end
    
    def do_get
      get :render_html
    end
    
    context "load_site before_filter" do
      it "should find the site for the page" do
        do_get
        assigns(:current_site).should == current_site
      end
    
      it "should not find the site for the page and return 404" do
        Site.stub(:match_domain).with("unknown_site.com").and_return(nil)
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
        current_site.should_receive(:pages).and_return(pages = [page])
        pages.should_receive(:where).and_return(criteria_pages = [page])
        criteria_pages.should_receive(:first).and_return(nil)
        do_get
        response.should render_template(404)
      end
    end
  end
end