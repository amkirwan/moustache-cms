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
    
    before(:each) do
      page.as_new_record
      Page.stub(:new).and_return(page)
    end
    
    def do_get
      get :new
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
  
  describe "POST create" do
    let(:layout) { mock_model("Layout") }
    let(:params) {{ "page" => { "title" => "foobar", "fitler" => "1", "published" => "1", "layout" => layout.to_param, "content" => "Hello, World!" }}}
    
    before(:each) do
      page.as_new_record
      Page.stub(:new).with(params["page"]).and_return(page)
    end
    
    def do_post
      post :create, params
    end
    
    it "should create a new page from the params" do
      Page.should_receive(:new).with(params["page"]).and_return(page)
      do_post
    end
    
    it "should assign @page for the view" do
      do_post
      assigns(:page).should == page
    end
    
    it "should assign created_by and updated by to the current user" do
      page.should_receive(:created_by=).with(current_user)
      page.should_receive(:updated_by=).with(current_user)
      do_post
    end
    
    context "when the page saves successfully" do
      it "should save the page" do
        page.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should create a flash message that the page was saved" do
        do_post
        flash[:notice].should == "Successfully created page #{page.title}"
      end
      
      it "should redirect to the pages#index page" do
        do_post
        response.should redirect_to(admin_pages_path)
      end     
    end
    
    context "when the page failes to save" do
      before(:each) do
        page.stub(:save).and_return(false)
      end
      
      it "should not save the page" do
        page.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/pages/new")
      end
    end
  end
end
