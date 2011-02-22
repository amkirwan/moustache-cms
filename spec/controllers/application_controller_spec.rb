require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')   

describe "ApplicationController" do
  controller do
    before_filter :current_user    
    def index 
      render :nothing => true
    end 
  end
  
  before(:each) do
    @current_user = mock_model('User') 
    User.stub_chain(:where, :first).and_return(@current_user)
  end
  
  describe "handling cancan call to current_user method" do 
    it "should should receive current_user" do
      controller.should_receive(:current_user)
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
    it "should receive admin? method" do
      controller.should_receive(:admin?).and_return(true)
      get :index
    end 
  end
end                                   