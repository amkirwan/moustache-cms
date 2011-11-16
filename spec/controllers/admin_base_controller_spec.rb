=begin
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')  

describe "AdminBaseController" do
  let(:current_admin_user) { logged_in(:role? => true) }
  
  controller(AdminBaseController) do
    def index 
      render :nothing => true
    end 
  end
  
  before(:each) do
    cas_faker(current_admin_user.username)
  end
  
  describe "cancan should call current_admin_user" do 
    it "assigns current_admin_user" do
      get :index
      assigns[:current_admin_user].should == current_admin_user
    end
  end  
end

describe AdminBaseController do
  let(:current_admin_user) { logged_in(:role? => true) }
  
  controller do
    def index
      admin?
      render :nothing => true
    end
  end
  
  before(:each) do
    cas_faker(current_admin_user.username)
  end
  
  describe "admin? method" do
    it "should receive admin? method and return true" do
      controller.should_receive(:admin?).and_return(true)
      get :index
    end
    
    it "should receive the admin? method and return false" do
      current_admin_user.stub(:role? => false)
      controller.should_receive(:admin?).and_return(false)
      get :index
    end
  end
end

describe AdminBaseController do
  let(:current_admin_user) { logged_in(:role? => true) }

  controller do 
    def index   
      created_updated_by_for(params["page"])
      render :nothing => true
    end 
  end
  
  before(:each) do
    @page = Page.new
    cas_faker(current_admin_user.username)
    controller.stub(:current_admin_user).and_return(current_admin_user)
  end
  
  describe "created_updated_by method" do
    it "should receive created_updated_by method" do
      controller.should_receive(:created_updated_by_for).with(@page)
      get :index, "page" => @page
    end
    
    it "should set created_by and updated_by to the current user" do
      get :index, "page" => @page
    end    
  end
end

describe AdminBaseController do
  let(:current_admin_user) { logged_in(:role? => true) }
  
  controller do
    def index 
      render :nothing => true
    end 
  end
  
  before(:each) do
    cas_faker(current_admin_user.username)
  end
  
  describe "should create a Site if one does not exist" do
    
  end
  
end
=end