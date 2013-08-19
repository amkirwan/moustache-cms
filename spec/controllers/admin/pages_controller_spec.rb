require 'spec_helper'

describe Admin::PagesController do

  let(:parent_page) { mock_model(Page, :site_id => @site.id) }
  
  before(:each) do
    login_admin
    @page_part = mock_model(PagePart)
    @page_parts = [@page_part]
    @page = mock_model(Page, :title => 'foobar', :parent => parent_page, :site_id => @site.id, :page_parts => @page_parts).as_null_object
  end
  
  # -- GET Index ----------------------------------------------- 
  describe "GET index" do
    def do_get     
      get :index
    end
    
    let(:pages) { [mock_model(Page), mock_model(Page)] }
    
    before(:each) do
      Page.stub(:accessible_by).and_return(pages)
      controller.stub(:root_pages)
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
  
  # -- GET show --------------
  describe "GET show" do
    before(:each) do
      Page.stub(:find).and_return(@page)
    end

    def do_get
      get :show, :id => @page.to_param
    end

    it "should assign @page" do
      do_get
      assigns[:page].should == @page
    end
  end

  # -- GET New ----------------------------------------------- 
  describe "GET new" do
    
    before(:each) do
      @page.as_new_record
      page_part = mock_model("PagePart", :name => "content")
      @page.stub_chain(:page_parts, :build)
      @page.stub_chain(:page_parts, :first).and_return(page_part)
      Page.stub(:new).and_return(@page)
    end
    
    def do_get
      get :new
    end
    
    it "should receive new and return a new page" do
      Page.should_receive(:new).and_return(@page)
      do_get
    end
    
    it "should assign @page for the view" do
      do_get
      assigns(:page).should == @page
    end

    it "should receive parent page" do
      controller.should_receive(:parent_page)
      do_get
    end
    
    it "should build a nested current_state" do
      @page.should_receive(:build_current_state)
      do_get
    end

    it "should build a neste page_parts" do
      @page.should_receive(:page_parts)
      do_get
    end

    it "should assign the selected page part" do
      do_get
      assigns[:selected_page_part].should_not be_nil
    end
    
    it "should render new template for page" do
      do_get
      response.should render_template("admin/pages/new")
    end   
  end

  # -- Post Create ----------------------------------------------- 
  describe "POST create" do

    let(:params) {{ "id" => @page.to_param, "page" => { "name" => "foobar" } }}
    
    before(:each) do
      @parent_mock = mock_model("Page", :id => '1')
      Page.stub_chain(:where, :find).and_return(@parent_mock)
      Page.stub(:new).with(params["page"]).and_return(@page)
    end
    
    def do_post
      post :create, params
    end
    
    it "should create a new page from the params" do
      Page.should_receive(:new).with(params["page"]).and_return(@page)
      do_post
    end
    
    it "should assign @page for the view" do
      do_post
      assigns(:page).should == @page
    end
    
    it "should assign the current_site to the page" do
      @page.should_receive(:site=).with(instance_of(Site))
      do_post
    end
    
    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(instance_of(Page))
      do_post
    end
    
    context "when the page saves successfully" do
      before(:each) do
        @page.stub(:save).and_return(true)
      end

      it "should save the page" do
        @page.should_receive(:save).and_return(true)
        do_post
      end

      it "should set the cookies" do
        controller.should_receive(:set_page_cookies)
        do_post
      end
      
      it "should create a flash message that the page was saved" do
        do_post
        flash[:notice].should == "Successfully created the page #{@page.title}"
      end
      
      it "should redirect to the pages#index page" do
        do_post
        response.should redirect_to(admin_pages_path)
      end     

      it "should redirect to edit page when continue param is set" do
        params["continue"] = "Save and Continue Editing"
        do_post
        response.should redirect_to(edit_admin_page_path(@page))
      end     
    end
    
    context "when the page fails to save" do
      before(:each) do
        @page.stub(:save).and_return(false)
        @page.stub(:errors => { :page => "page errors" })
      end
      
      it "should not save the page" do
        @page.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/pages/new")
      end
    end 
  end
  
  # -- GET edit ----------------------------------------------- 
  describe "GET edit" do
    let(:params) {{ "id" => @page.to_param }}
    
    before(:each) do
      Page.stub(:find).and_return(@page)
    end
    
    def do_get
      get :edit, params
    end
    
    it "should receive Layout#find and return layout" do
      Page.should_receive(:find).with(params["id"]).and_return(@page)
      do_get
    end
    
    it "should assing @layout for the veiw" do
      do_get
      assigns(:page).should == @page
    end

    it "should receive selected_part" do
      controller.should_receive(:selected_page_part)
      do_get
    end


    it "should receive parent page" do
      controller.should_receive(:parent_page)
      do_get
    end

    it "should assign the selected_page_part" do
      do_get
      assigns(:selected_page_part).should ==  @page.page_parts.first
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template("admin/pages/edit")
    end
  end
  
  # -- Puts Update ----------------------------------------------- 
  describe "PUTS update" do
    let(:params) {{ "id" => @page.to_param, "page" => { "name" => "foobar" } }}

    def do_puts(puts_params=params)
       put :update, puts_params
    end
    
    before(:each) do
      @parent_mock = mock_model("Page", :id => '1')
      Page.stub(:find).and_return(@page)
    end 
    
    it "should find the record to update with Page#find" do
      Page.should_receive(:find).with(params["id"]).and_return(@page)
      do_puts
    end
    
    it "should assign @page for the view" do
      do_puts
      assigns(:page).should == @page
    end

    it "should assign page title was" do
      do_puts
      assigns[:page_title_was].should == @page.title
    end
    
    context "with valid params" do
      before(:each) do
        @page.stub(:update_attributes).and_return(true)
      end

      it "should update the attributes of the page" do
        @page.should_receive(:update_attributes).with(params["page"]) 
        do_puts
      end
    
      it "should assign the flash message" do
        do_puts
        flash[:notice].should == "Successfully updated the page #{@page.title}"
      end
      
      it "should redirect to the admin/layout#index action" do
        do_puts
        response.should redirect_to(admin_pages_path)
      end

      it "should redirect to edit page when the continue param is set" do
        params["continue"] = "Save and Continue Editing"
        do_puts
        response.should redirect_to(edit_admin_page_path(@page))
      end     

    end
    
    context "with invalid params" do
      it "should render the edit template" do
        @page.stub(:update_attributes).and_return(false)
        @page.stub(:errors => { :page => "user errors" })
        do_puts  
        response.should render_template("admin/pages/edit")
      end
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      Page.stub(:find).and_return(@page)
      @page.stub(:persisted?).and_return(false)
    end
    
    def do_destroy  
      delete :destroy, :id => @page.id
    end
    
    it "should receive Page#find and return the page" do
      Page.should_receive(:find).with(@page.id.to_s).and_return(@page)
      do_destroy
    end
    
    it "should assign the page for the view" do
      do_destroy
      assigns(:page).should == @page
    end
    
    it "should destroy the page" do
      @page.should_receive(:destroy).and_return(true)
      do_destroy
    end
    
    it "should assign a flash message that the letter was destroyed" do
      do_destroy
      flash[:notice].should == "Successfully deleted the page #{@page.title}"
    end
    
    it "should redirect to the admin/layout#index" do
      do_destroy
      response.should redirect_to(admin_pages_path)
    end
  end

  describe "POST set_state" do

    before(:each) do
      Page.stub(:set_state).and_return(true)
    end

    def do_post(params)
      post :set_state, params
    end
    
    describe "publish all" do
      let(:params) {{ "publish" => "Publish All Pages" }}

      it "should create a new page from the params" do
        Page.should_receive(:publish_all).with(instance_of(Site))
        do_post(params)
      end

      it "should create a flash message that the pages were published" do
        do_post(params)
        flash[:notice].should == "Published all the pages for the site."
      end

      it "should redirect to the admin/layout#index" do
        do_post(params)
        response.should redirect_to(admin_pages_path)
      end
    end

    
    describe "draft all" do
      let(:params) {{ "draft" => "Draft All Pages" }}

      it "should create a new page from the params" do
        Page.should_receive(:draft_all).with(instance_of(Site))
        do_post(params)
      end

      it "should create a flash message that the pages were published" do
        do_post(params)
        flash[:notice].should == "All pages set to draft for the site."
      end

      it "should redirect to the admin/layout#index" do
        do_post(params)
        response.should redirect_to(admin_pages_path)
      end
    end

  end

end
