require 'spec_helper'

describe Admin::PagesController do
  
  #for actions
  let(:current_user) { logged_in(:role? => true) }
  let(:page) { mock_model("Page").as_null_object }
  
  before(:each) do
    cas_faker(current_user.username)
  end
  
  describe "GET index" do
    def do_get     
      get :index
    end
    
    let(:pages) { [mock_model("Pages"), mock_model("Pges")] }
    
    before(:each) do
      Page.stub(:accessible_by).and_return(pages)
    end
    
    it "should receive accessible_by" do
      Page.should_receive(:accessible_by).and_return(pages)
      do_get
    end
    
    it "should assign the found users" do
      do_get
      assigns(:pages).should == pages
    end
  
    it "should render index template" do
      do_get
      response.should render_template("admin/pages/index")
    end
  end
  
  describe "GET new" do
    def do_get
      get :new
    end
    
    before(:each) do
      page.as_new_record
      Page.stub(:new).and_return(page)
    end
    
    it "should receive new and return a new page" do
      Page.should_receive(:new).and_return(page)
      do_get
    end
    
    it "should assign @page for the view" do
      do_get
      assigns(:page).should == page
    end
    
    it "should render new template for page" do
      do_get
      response.should render_template("admin/pages/new")
    end
    
  end
end
