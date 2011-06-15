require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe CmsSiteController do
  render_views
   
  # -- GET dynamic_page ----------------------------------------------- 
  describe "GET dynamic_page" do
    
    let(:current_site) { Factory(:site)}
    let(:page) { Factory(:page, :site => current_site)}
    
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
        
        it "should respond with 200" do
          do_get
          response.code.should == "200"
        end
      end
    
      context "invalid params" do
        it "should not find the site for the page and return 404" do
          @criteria_sites.stub(:first).and_return(nil)
          do_get
          response.code.should == "404"
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
          current_site.should_receive(:page_by_full_path).and_return(nil)
          do_get
          response.code.should == "404"
        end
      end
    end
    
    context "render css" do
      describe "when the request is for a css file route to css path" do
        
      end
    end
  end
end