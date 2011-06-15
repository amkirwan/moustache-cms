require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe CmsSiteController do
   
  # -- GET dynamic_page ----------------------------------------------- 
  describe "GET dynamic_page" do
    
    let(:page) { mock_model("Page").as_null_object }
    let(:current_site) { mock_model("Site", :pages => [page]) }
    
    before(:each) do
      Site.stub(:match_domain).with("test.host").and_return(@criteria_sites = [current_site])
      @criteria_sites.stub(:first).and_return(current_site)
      current_site.stub(:page_by_full_path).and_return(page)
    end
    
    def do_get
      get :render_html
    end
    
    describe "load_site before_filter" do
           
      context "valid params" do
        it "should find the site" do
          do_get
          assigns(:current_site).should == current_site
        end
      end
    
      context "invalid params" do
        it "should not find the site for the page and return 404" do
          Site.stub(:match_domain).with("unknown_site.com").and_return(nil)
          do_get
          response.should render_template(404)
        end
      end
    end
    
    context "load_page before_fitler" do
      
      context "valid params" do
        it "should find the page for the site" do
          do_get
          assigns(:page).should == page
        end    
      end
      
      context "valid params" do
        it "should not find the page and return 404" do
          current_site.should_receive(:page_by_full_path).and_return(page)
          do_get
          response.should render_template(404)
        end
      end
    end
  end
end