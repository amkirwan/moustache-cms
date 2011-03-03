require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe Admin::LayoutsController do
  describe "it should require an admin to access these actions" do
    it_should_require_admin_for_action Layout, :index, :show, :new, :update, :create, :edit, :destroy 
  end
  
  describe "it should allow admin to access all actions" do
    it_should_allow_admin_for_action Layout, :index, :show, :new, :update, :create, :edit, :destroy
  end
  
  let(:current_user) { logged_in(:role? => true) }
  let(:layout) { mock_model("Layout").as_null_object }
  
  before(:each) do
    cas_faker(current_user.username)
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
end