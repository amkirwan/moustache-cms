require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe Admin::LayoutsController do
  describe "it should require an admin to access these actions" do
    it_should_require_admin_for_action Layout, :index, :new, :update, :create, :edit, :destroy 
  end
  
  describe "it should allow admin to access all actions" do
    it_should_allow_admin_for_action Layout, :index, :new, :update, :create, :edit, :destroy
  end
  
  let(:current_user) { logged_in(:role? => true) }
  let(:layout) { mock_model("Layout").as_null_object }
  
  before(:each) do
    cas_faker(current_user.puid)
  end
  
  describe "GET index" do    
    let(:layouts) { [mock_model(Layout, :name => "foobar"), mock_model(Layout, :name => "bar")] }
      
    before(:each) do
      Layout.stub(:accessible_by).and_return(layouts)
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
      layout.as_new_record
      Layout.stub(:new).and_return(layout)
    end
    
    it "should receive new and return a new layout" do
      Layout.should_receive(:new).and_return(layout)
      do_get
    end
    
    it "should assign the new layout for the view" do
      do_get
      assigns(:layout).should == layout
    end
    
    it "should render the new template" do
      do_get
      response.should render_template("admin/layouts/new")
    end
  end
  
  describe "POST create" do
    let(:params) {{ "layout" => { "name" => "foobar", "content" => "Hello, World" }}}
    
    before(:each) do
      layout.as_new_record
      controller.stub(:admin?).and_return(true)
      Layout.stub(:new).and_return(layout)
    end
    
    def do_post
      post :create, params
    end
    
    it "should create a new layout from the params" do
      Layout.should_receive(:new).with(params["layout"]).and_return(layout)
      do_post
    end
    
    it "should assign @layout for the view" do
      do_post
      assigns(:layout).should == layout
    end
    
    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(layout)
      do_post
    end
    
    context "when it saves the layout successfully" do
      it "should receive save the layout" do
        layout.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should assign a flash message that the layout was saved" do
        do_post
        flash[:notice].should == "Successfully created the layout #{layout.name}"
      end
      
      it "should redirect to admin/layout#index" do
        do_post
        response.should redirect_to(admin_layouts_path)
      end
    end
    
    context "when the layout fales to save" do
      before(:each) do
        layout.stub(:save).and_return(false)
      end
      
      it "should render the layout new" do
        layout.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/layouts/new")
      end
    end
  end
  
  describe "GET edit" do
    let(:params) {{ "id" => layout.to_param }}
    
    before(:each) do
      Layout.stub(:find).and_return(layout)
    end
    
    def do_get
      get :edit, params
    end
    
    it "should receive Layout#find and return layout" do
      Layout.should_receive(:find).with(params["id"]).and_return(layout)
      do_get
    end
    
    it "should assing @layout for the veiw" do
      do_get
      assigns(:layout).should == layout
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template("admin/layouts/edit")
    end
  end
  
  describe "PUTS update" do
    let(:params) {{ "id" => layout.to_param, "layout" => { "name" => "foobar", "content" => "Hello, World" }}}
    
    before(:each) do
      controller.stub(:admin?).and_return(true)
      Layout.stub(:find).and_return(layout)
    end
    
    def do_post
      post :update, params
    end
    
    it "should find the record to update with Layout#find" do
      Layout.should_receive(:find).with(params["id"]).and_return(layout)
      do_post
    end
    
    it "should assign @layout for the view" do
      do_post
      assigns(:layout).should == layout
    end
    
    it "should update the attributes of the layout" do
      layout.should_receive(:attributes=).with(params["layout"])
      do_post
    end
    
    it "should update protected attributes" do
      layout.should_receive(:updated_by=).with(current_user)
      do_post
    end
    
    context "when the layer saves successfully" do
      it "should save the layout" do
        layout.should_receive(:save).and_return(true)
        do_post
      end
    
      it "should assign the flash message" do
        do_post
        flash[:notice].should == "Successfully updated the layout #{layout.name}"
      end
      
      it "should redirect to the admin/layout#index action" do
        do_post
        response.should redirect_to(admin_layouts_path)
      end
    end
    
    context "when the layout fales to save" do
      before(:each) do
        layout.stub(:save).and_return(false)
      end
      
      it "should not save the layout" do
        layout.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the layout edit" do
        do_post
        response.should render_template("admin/layouts/edit")
      end
    end   
  end
  
  describe "DELETE destroy" do
    before(:each) do
      Layout.stub(:find).and_return(layout)
    end
    
    def do_destroy  
      delete :destroy, :id => "1"
    end
    
    it "should receive Layout#find and return the layout" do
      Layout.should_receive(:find).with("1").and_return(layout)
      do_destroy
    end
    
    it "should assign the layout for the view" do
      do_destroy
      assigns(:layout).should == layout
    end
    
    it "should destroy the layout" do
      layout.should_receive(:destroy).and_return(true)
      do_destroy
    end
    
    it "should assign a flash message that the letter was destroyed" do
      do_destroy
      flash[:notice].should == "Successfully deleted the layout #{layout.name}"
    end
    
    it "should redirect to the admin/layout#index" do
      do_destroy
      response.should redirect_to(admin_layouts_path)
    end
  end
end







