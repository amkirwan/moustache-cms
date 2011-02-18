require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')     

describe Admin::UsersController do
  describe "GET index" do   
    def do_get(username="foobar")  
      cas_faker(username)    
      get :index
    end
           
    context "when the user is an admin they can view user records" do
      let(:users) { [mock_model("User", :username => "foo", :role => "admin"),
                    mock_model("User", :username => "bar", :role => "editor")] }    
     
      before do                                    
        logged_in(:role? => true)
        User.stub(:all).and_return(users)     
      end             
    
      it "should receive find all" do   
        User.should_receive(:all).and_return(users)
        do_get
      end
    
      it "should assign the found users" do
        do_get
        assigns[:users].should == users
      end
    
      it "should render index template" do
        do_get
        response.should render_template("admin/users/index")
      end  
    end   
    
    context "when the user is not an admin they should not be authorized" do  
      before do                   
        logged_in(:role? => false) 
      end  
      
      it "should not receive the index action" do
        controller.should_not_receive(:index)
        do_get
      end
      
      it "should show flash message Access Denied!" do
        do_get
        flash[:error].should == ("Access Denied!")
      end
    end 
  end
  
  describe "GET new" do  
    def do_get(username="foobar")  
      cas_faker(username)    
      get :new
    end  
    
    let(:user) { mock_model(User).as_null_object.as_new_record } 
    
    before(:each) do 
      User.stub(:new).and_return(user)
      logged_in(:role? => true)
    end  
    
    it "should receive new the new and return a new user" do   
      User.should_receive(:new).and_return(user)
      do_get
    end
  
    it "should assign the found user" do
      do_get
      assigns(:user).should eq(user)
    end
  
    it "should render new template" do
      do_get
      response.should render_template("admin/users/new")
    end
  end     
  
  
  describe "POST create" do 
    before(:each) do   
      @logged_in = mock_model(User, :role? => true).as_null_object  
      @new_user = mock_model(User, :save => nil).as_null_object.as_new_record  
      @params = { "user" => { "username" => "foobar", "email" => "foobar@example.com", "role" => "admin" }}     
      User.stub(:new).and_return(@new_user)
      stub_current_user(@logged_in)
    end  
    
    def do_post(params=@params, username=@logged_in)       
      cas_faker(username)
      post :create, params
    end  
              
    it "should create a new user" do
      User.should_receive(:new).with(@params["user"]).and_return(@new_user) 
      do_post                                                               
      assigns(:user).should eq(@new_user) 
    end  
  
    it "should receive save the user" do
      @new_user.should_receive(:save)
      do_post
    end   
    
    context "when it save the new user successfully" do
      before(:each) do
        @new_user.stub(:save).and_return(true)
      end         
      
      it "should should create a flash notice" do 
        do_post
        flash[:notice].should == "Successfully created user account for #{@new_user.username}"
      end 
      
      it "should redirect to the admin users path" do
        do_post
        response.should redirect_to(admin_users_path)
      end
    end
    
    context "when the save fails" do                    
      it "should redirect to new template" do             
        do_post
        response.should render_template("admin/users/new")
      end
    end
    
    context "when the user is not an admin the CREATE action should not be actionable" do 
      before(:each) do
        @non_admin = mock_model(User, :role? => false).as_null_object
        stub_current_user(@non_admin)
      end 
      
      it "should not go to the CREATE action" do 
        controller.stub(:render)
        controller.should_not_receive(:create)
        do_post
      end 
    end  
  end 
  
  describe "Get edit" do
  end
end
