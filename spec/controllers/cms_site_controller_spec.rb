require 'spec_helper'

describe CmsSiteController do
  render_views
   
  # -- GET dynamic_page ----------------------------------------------- 
  describe "GET dynamic_page" do
    
    let(:current_site) { FactoryGirl.build(:site)}
    let(:layout) { FactoryGirl.build(:layout, :site => current_site) }
    let(:page) { mock_model(Page, :layout => layout, :published? => true).as_null_object }
    
    before(:each) do
      Site.stub(:match_domain).with("test.host").and_return(@criteria_sites = [current_site])
      @criteria_sites.stub(:first).and_return(current_site)
      current_site.stub(:page_by_full_path).and_return(page)
    end
    
    def do_get
      get :render_html
    end

    describe "requset_set before_filter" do
      it "should set the request params" do
        do_get
        assigns(:request).should_not be_nil
      end
    end
    
    describe "load_page before_fitler" do
      context "valid params" do
        it "should find the page for the site" do
          do_get
          assigns(:page).should == page
        end    
      end
      
      context "invalid params" do
        it "should not find the page and return 404" do
          current_site.should_receive(:page_by_full_path).and_return(nil)
          do_get
          response.code.should == "404"
        end
      end
    end

    describe "render_html" do
      context "valid params" do
        it "should render the mustache response" do
          do_get
          response.code.should == "200"
        end
      end

      context "page is not published" do
        it "should not render the page if the user is not logged in" do
          page.stub(:published? => false)
          do_get
          response.code.should == "404"
        end

        it "should render the page if the user is an admin user" do
          page.stub(:published? => false)
          controller.stub(:current_admin_user).and_return(true)
          do_get
          response.code.should == "200"
        end
      end
    end

  end
end
