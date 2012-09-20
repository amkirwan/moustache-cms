require 'spec_helper'

describe Admin::LayoutsController do
  
  before(:each) do
    login_admin
    @layout = mock_model(Layout, :site_id => @site.id).as_null_object
  end
  
  describe "GET index" do    
    let(:layouts) { [@layout] }
      
    before(:each) do
      Layout.stub(:accessible_by).and_return(layouts)
      layouts.stub_chain(:where, :order_by).and_return(layouts)
    end
    
    def do_get
      get :index
    end
      
    it "should receive accessible_by" do
      Layout.should_receive(:accessible_by).and_return(layouts)
      do_get
    end

    it "should assign the found layouts" do
      do_get
      assigns(:layouts).should == layouts
    end

    it "should only show the layouts for the site" do
      layouts.should_receive(:where).with(:site_id => @current_admin_user.site_id)
      do_get  
    end
    
    it "should render the index template" do
      do_get
      response.should render_template("admin/layouts/index")
    end
  end
  
  describe "GET new" do
    def do_get
      get :new
    end
    
    before(:each) do
      @layout.as_new_record
      Layout.stub(:new).and_return(@layout)
    end
    
    it "should receive new and return a new layout" do
      Layout.should_receive(:new).and_return(@layout)
      do_get
    end
    
    it "should assign the new layout for the view" do
      do_get
      assigns(:layout).should == @layout
    end
    
    it "should render the new template" do
      do_get
      response.should render_template("admin/layouts/new")
    end
  end
  
  describe "POST create" do
    let(:params) {{ "layout" => { "name" => "foobar", "content" => "Hello, World" }}}
    
    before(:each) do
      controller.stub(:admin?).and_return(true)
      Layout.stub(:new).and_return(@layout)
    end
    
    def do_post(post_params=params)
      post :create, post_params
    end
    
    it "should create a new layout from the params" do
      Layout.should_receive(:new).with(params["layout"]).and_return(@layout)
      do_post
    end

    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(instance_of(Layout))
      do_post
    end
    
    it "should assign @layout for the view" do
      do_post
      assigns(:layout).should == @layout
    end
    
    it "should assign the current_site" do
      @layout.should_receive(:site=).with(instance_of(Site))
      do_post
    end
    
    context "when it saves the layout successfully" do
      before(:each) do
        @layout.stub(:save).and_return(true)
      end

      it "should save the layout" do
        @layout.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should assign a flash message that the layout was saved" do
        do_post
        flash[:notice].should == "Successfully created the layout #{@layout.name}"
      end
      
      it "should redirect to admin/layout#index" do
        do_post
        response.should redirect_to(admin_layouts_path)
      end

      it "should redirect to edit layout when the continue param is set" do
        new_params = params
        new_params["continue"] = "Save and Continue Editing"
        do_post new_params
        response.should redirect_to(edit_admin_layout_path(@layout))
      end
    end
    
    context "when the layout fails to save" do
      before(:each) do
        @layout.stub(:save).and_return(false)
        @layout.stub(:errors => { :anything => "layout errors" })
      end
      
      it "should receive save and return false" do
        @layout.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/layouts/new")
      end
    end
  end
  
  describe "GET edit" do
    let(:params) {{ "id" => @layout.to_param }}
    
    before(:each) do
      Layout.stub(:find).and_return(@layout)
    end
    
    def do_get
      get :edit, params
    end
    
    it "should receive Layout#find and return layout" do
      Layout.should_receive(:find).with(params["id"]).and_return(@layout)
      do_get
    end
    
    it "should assing @layout for the veiw" do
      do_get
      assigns(:layout).should == @layout
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template("admin/layouts/edit")
    end
  end
  
  describe "PUTS update" do
    let(:params) {{ "id" => @layout.to_param, "layout" => { "name" => "foobar", "content" => "Hello, World" }}}
    
    before(:each) do
      controller.stub(:admin?).and_return(true)
      Layout.stub(:find).and_return(@layout)
    end
    
    def do_put(put_params=params)
      put :update, put_params
    end
    
    it "should find the record to update with Layout#find" do
      Layout.should_receive(:find).with(params["id"]).and_return(@layout)
      do_put
    end
    
    it "should assign @layout for the view" do
      do_put
      assigns(:layout).should == @layout
    end
    
    it "should update protected attributes" do
      @layout.should_receive(:updated_by=).with(@admin_user)
      do_put
    end
    
    context "valid params" do
      before(:each) do
        @layout.stub(:update_attributes).and_return(true)
      end

      it "should update the attributes of the layout" do
        @layout.should_receive(:update_attributes).with(params["layout"])
        do_put
      end
    
      it "should assign the flash message" do
        do_put
        flash[:notice].should == "Successfully updated the layout #{@layout.name}"
      end
      
      it "should redirect to the admin/layout#index action" do
        do_put
        response.should redirect_to(admin_layouts_path)
      end

      it "should redirect to edit layout when there is a continue param set" do
        new_params = params
        new_params["continue"] = "Save and Continue Editing"
        do_put new_params
        response.should redirect_to(edit_admin_layout_path(@layout))
      end

      it "should redirect to admin/layout#index" do
        do_put
        response.should redirect_to(admin_layouts_path)
      end
    end
    
    context "when the layout fales to save" do
      before(:each) do
        @layout.stub(:update_attributes).and_return(false)
        @layout.stub(:errors => { :layout => "layout errors" })
      end
      
      it "should not save the layout" do
        @layout.should_receive(:update_attributes).and_return(false)
        do_put
      end
      
      it "should render the layout edit" do
        do_put
        response.should render_template("admin/layouts/edit")
      end
    end   
  end
  
  describe "DELETE destroy" do
    before(:each) do
      Layout.stub(:find).and_return(@layout)
      @layout.stub(:persisted?).and_return(false)
    end
    
    def do_destroy  
      delete :destroy, :id => @layout.id
    end
    
    it "should receive Layout#find and return the layout" do
      Layout.should_receive(:find).with(@layout.id.to_s).and_return(@layout)
      do_destroy
    end
    
    it "should assign the layout for the view" do
      do_destroy
      assigns(:layout).should == @layout
    end
    
    it "should destroy the layout" do
      @layout.should_receive(:destroy).and_return(true)
      do_destroy
    end
    
    it "should assign a flash message that the letter was destroyed" do
      do_destroy
      flash[:notice].should == "Successfully deleted the layout #{@layout.name}"
    end
    
    it "should redirect to the admin/layout#index" do
      do_destroy
      response.should redirect_to(admin_layouts_path)
    end
  end
end



