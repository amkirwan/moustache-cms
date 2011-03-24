require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe SiteController do
  describe "dynamic_page" do
    def do_get
      get :dynamic_page
    end
    
    let(:page) { mock_model("Page") }
    before(:each) do
      Page.stub(:find_by_path).and_return(page)
    end
    
    it "should should receive show method" do
      controller.should_receive(:dynamic_page)
      do_get
    end
       
    it "should assign @page" do
      do_get
      assigns(:page).should == page
    end
  end
end