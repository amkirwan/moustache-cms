require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')  

describe Admin::PagesController do
  let(:site) { mock_model(Site, :id => "1") }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:page) { mock_model("Page", :site_id => site.id).as_null_object }
  
  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)
  end
  
  # -- GET Index ----------------------------------------------- 
  describe "GET index" do
    def do_get     
      get :index
    end
    
    let(:pages) { [mock_model("Pages"), mock_model("Pages")] }
    
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
  
  # -- GET New ----------------------------------------------- 
  describe "GET new" do
    
    before(:each) do
      page.as_new_record
      page.stub_chain(:page_parts, :build).and_return([mock_model("PagePart")])
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
    
    it "should build a nested current_state" do
      page.should_receive(:build_current_state)
      do_get
    end
    
    it "should build a neste page_parts" do
      page.should_receive(:page_parts)
      do_get
    end
    
    it "should render new template for page" do
      do_get
      response.should render_template("admin/pages/new")
    end   
  end
  
  # -- Post Create ----------------------------------------------- 
  describe "POST create" do
    let(:page_type) { mock_model("PageType") }
    let(:status) { mock_model("CurrentStatus") }
    let(:filter) { mock_model("Filter", :name => "foobar") }
    let(:layout) { mock_model("Layout") }
    let(:page_parts) { [ mock_model("PagePart") ] }
    let(:params) {{ "page" => { 
                    "parent_id" => "4d922d505dfe2f082e00006e",
                    "name" => "foobar",
                    "title" => "foobar", 
                    "filter" => { "name" => filter.name }, 
                    "meta_data" => { "title" => "foobar", "keywords" => "foobar, keywords", "description" => "foobar description"},
                    "page_type_attributes"=> { "id" => page_type.to_param },
                    "current_state_attributes"=> { "id"=> status.to_param }, 
                    "editor_ids"=>["#{current_user.to_param}"],
                    "layout_id" => layout.to_param,
                    "page_parts_attributes" => { "0" => { "name" => "content", "content" => "Hello, World" }}} }}
    
    before(:each) do
      page.as_new_record
      @parent_mock = mock_model("Page", :id => "4d922d505dfe2f082e00006e")
      Page.stub(:find).and_return(@parent_mock)
      User.stub(:find).and_return(current_user)
      CurrentState.stub(:find).and_return(status)
      Filter.stub(:find).and_return(filter)
      Page.stub(:new).with(params["page"]).and_return(page)
    end
    
    def do_post
      post :create, params
    end
    
    it "should create a new page from the params" do
      Page.should_receive(:new).with(params["page"]).and_return(page)
      do_post
    end
    
    it "should set the parent_id to the parent selected" do
      page.should_receive(:parent_id=)
      do_post
      page.parent_id.should_not == nil
    end
    
    it "should assign @page for the view" do
      do_post
      assigns(:page).should == page
    end
    
    it "should set the current_state" do
      controller.should_receive(:assign_current_state).with(params["page"]["current_state_attributes"]["name"])
      do_post
    end
    
    it "should assign the current_site to the page" do
      page.should_receive(:site=)
      do_post
    end
    
    it "should set the page editors" do
      controller.should_receive(:assign_editors).with(params["page"]["editor_ids"])
      do_post
    end
    
    it "should set the page parts" do
      controller.should_receive(:assign_page_parts).with(params["page"]["page_parts_attributes"])
      do_post
    end
    
    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(page)
      do_post
    end
    
    context "when the parent page is blank" do
      it "should set the parent_id to nil when the parent_id is blank" do
        params["page"]["parent_id"] = nil
        page.should_receive(:parent_id=).with(nil)
        do_post
      end
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
  
  # -- GETE edit ----------------------------------------------- 
  describe "GET edit" do
    let(:params) {{ "id" => page.to_param }}
    
    before(:each) do
      Page.stub(:find).and_return(page)
    end
    
    def do_get
      get :edit, params
    end
    
    it "should receive Layout#find and return layout" do
      Page.should_receive(:find).with(params["id"]).and_return(page)
      do_get
    end
    
    it "should assing @layout for the veiw" do
      do_get
      assigns(:page).should == page
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template("admin/pages/edit")
    end
  end
  
  # -- Puts Update ----------------------------------------------- 
  describe "PUTS update" do
    let(:user) { mock_model("User", :puid => "ak730") }
    let(:page_type) { mock_model("PageType") }
    let(:status) { mock_model("CurrentStatus").as_null_object }
    let(:filter) { mock_model("Filter", :name => "foobar") }
    let(:layout) { mock_model("Layout") }
    let(:page_parts) { [ mock_model("PagePart") ] }
    let(:params) {{ "id" => page.to_param,
                    "page" => { 
                    "parent_id" => "4d922d505dfe2f082e00006e",
                    "name" => "foobar",
                    "title" => "foobar", 
                    "page_type_attributes"=> { "id" => page_type.to_param },
                    "current_state_attributes"=> { "id"=> status.to_param }, 
                    "editor_ids"=>[ user.to_param ], 
                    "layout_id" => layout.to_param,
                    "page_parts_attributes" => { "0" => { "name" => "content", "content" => "Hello, World", "filter_name" => filter.name }}} }}
    
    before(:each) do
      controller.stub(:admin?).and_return(true)
      @parent_mock = mock_model("Page", :id => "4d922d505dfe2f082e00006e")
      User.stub(:find).and_return(user)
      CurrentState.stub(:find_by_name).and_return(status)
      Page.stub(:find).and_return(page)
    end 
    
    def do_post
       post :update, params
    end
    
    it "should find the record to update with Page#find" do
      Page.should_receive(:find).with(params["id"]).and_return(page)
      do_post
    end
    
    it "should assign @page for the view" do
      do_post
      assigns(:page).should == page
    end
    
    it "should update the page's current state" do
      controller.should_receive(:update_current_state).with(params["page"]["current_state_attributes"]["name"])
      do_post
    end
    
    it "should update the page editors" do
      controller.should_receive(:update_editors).with(params["page"]["editor_ids"])
      do_post
    end
    
    it "should update the page_parts" do
      controller.should_receive(:update_page_parts).with(params["page"]["page_parts_attributes"])
      do_post
    end
    
    context "with valid params" do
      it "should update the attributes of the page" do
        page.should_receive(:update_attributes).with(params["page"]) 
        do_post
      end
    
      it "should assign the flash message" do
        do_post
        flash[:notice].should == "Successfully updated the page #{page.title}"
      end
      
      it "should redirect to the admin/layout#index action" do
        do_post
        response.should redirect_to(admin_pages_path)
      end
    end
    
    context "with invalid params" do
      before(:each) do
        page.stub(:update_attributes).and_return(false)
      end
      
      it "should not save the page" do
        page.should_receive(:update_attributes).and_return(false)
        do_post
      end
      
      it "should render the page edit" do
        do_post
        response.should render_template("admin/pages/edit")
      end
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      Page.stub(:find).and_return(page)
    end
    
    def do_destroy  
      delete :destroy, :id => "1"
    end
    
    it "should receive Page#find and return the page" do
      Page.should_receive(:find).with("1").and_return(page)
      do_destroy
    end
    
    it "should assign the page for the view" do
      do_destroy
      assigns(:page).should == page
    end
    
    it "should destroy the page" do
      page.should_receive(:destroy).and_return(true)
      do_destroy
    end
    
    it "should assign a flash message that the letter was destroyed" do
      do_destroy
      flash[:notice].should == "Successfully deleted the page #{page.title}"
    end
    
    it "should redirect to the admin/layout#index" do
      do_destroy
      response.should redirect_to(admin_pages_path)
    end
  end
end
