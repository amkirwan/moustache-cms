require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')  

describe "ApplicationController" do
  controller do
    before_filter :current_user    
    def index 
      render :nothing => true
    end 
  end
  
  before(:each) do
    @current_user = mock_model("User", :role? => true)
    User.stub_chain(:where, :first).and_return(@current_user)
  end
  
  describe "handling cancan call to current_user method" do 
    it "should should receive current_user" do
      controller.should_receive(:current_user).and_return(@current_user)
      get :index
    end
    
    it "current user should return the user" do
      get :index
      assigns[:current_user].should == @current_user
    end
  end  
end 

describe "ApplicationController" do
  controller do 
    before_filter :current_user
    def index    
      admin?
      render :nothing => true
    end 
  end 
  
  before(:each) do
    @current_user = mock_model("User", :role? => true)
    User.stub_chain(:where, :first).and_return(@current_user)
  end
  
  describe "admin? method" do
    it "should receive admin? method and return true" do
      controller.should_receive(:admin?).and_return(true)
      get :index
    end
    
    it "should receive admin? method and return false" do 
      @current_user.stub(:role? => false)
      controller.should_receive(:admin?).and_return(false)
      get :index
    end
  end
end 

describe "ApplicationController" do
  controller do 
    before_filter :current_user
    def index   
      created_updated_by_for(params["page"])
      render :nothing => true
    end 
  end
  
  before(:each) do
    @page = Page.new
    @current_user = mock_model("User", :role? => true).as_null_object
    User.stub_chain(:where, :first).and_return(@current_user)
  end
  
  describe "created_updated_by method" do
    it "should receive created_updated_by method" do
      controller.should_receive(:created_updated_by_for).with(@page)
      get :index, "page" => @page
    end
    
    it "should set created_by and updated_by to the current user" do
      get :index, "page" => @page
      @page.created_by.should == @current_user
      @page.updated_by.should == @current_user
    end    
  end
end                                