require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe Admin::UsersController do
  
  # check authorization
  describe "it should require an admin to access these actions" do
    it_should_require_admin_for_action User, :index, :show, :new, :update, :create, :edit, :destroy 
  end
  
  describe "it should allow admin to access all actions" do
    it_should_allow_admin_for_action User, :index, :show, :new, :update, :create, :edit, :destroy
  end
  
  describe "it should allow non admin to edit & update their record only" do
    it_should_allow_non_admin_for_action User, :edit, :params => "1"
    it_should_allow_non_admin_for_action User, :update, :params => "1"
    it_should_allow_non_admin_for_action User, :show, :params => "1"   
  end
  
  #for actions
  let(:current_user) { logged_in(:role? => true) }
  let(:user) { mock_model("User").as_null_object }
  
  before(:each) do
    cas_faker(current_user.puid)
  end
  
  describe "GET index" do
    def do_get     
      get :index
    end
           
    context "when the user is an admin they can view user records" do
      let(:users) { [mock_model("User", :puid => "foo", :role => "admin"),
                    mock_model("User", :puid => "bar", :role => "editor")] } 
      
      before(:each) do
        User.stub(:accessible_by).and_return(users)
      end
      
      it "should receive accessible_by" do
        User.should_receive(:accessible_by).and_return(users)
        do_get
      end
      
      it "should assign the found users" do
        do_get
        assigns(:users).should eq(users)
      end
    
      it "should render index template" do
        do_get
        response.should render_template("admin/users/index")
      end  
    end   
  end
  
  describe "GET show" do
    before(:each) do
      User.stub(:find).and_return(user)
    end
    
    let(:params) {{ :id => "1" }}
    def do_get
      get :show, :id => "1"
    end
    
    it "should should receive find" do
      User.should_receive(:find).with(params[:id]).and_return(user)
      do_get
    end
    
    it "should assign @user for the view" do
      do_get
      assigns(:user).should eq(user)
    end
    
    it "should render the EDIT template" do
      do_get
      response.should render_template("admin/users/edit")
    end
  end
  
  describe "GET new" do    
    
    before(:each) do 
      user.as_new_record
      User.stub(:new).and_return(user)   
    end
    
    def do_get     
      get :new
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
    let(:params) {{ "user" => { "puid" => "foobar", "puid" => "foobar", "firstname" => "foo", "lastname" => "bar", "email" => "foobar@example.com", "role" => "admin" }}}
    
    before(:each) do 
      user.as_new_record   
      controller.stub(:admin?).and_return(true)
      User.stub(:new).and_return(user)
    end  
    
    def do_post       
      post :create, params
    end  
              
    it "should create a new user" do
      User.should_receive(:new).with(params["user"]).and_return(user)
      do_post 
      assigns(:user).should eq(user)                                                              
    end 
    
    it "should assign the puid value" do
      user.should_receive(:puid=).with(params["user"]["puid"])
      do_post
    end
    
    it "should assign the role value" do
      user.should_receive(:role=).with(params["user"]["role"])
      do_post
    end
    
    context "when it save the new user successfully" do  
      
      it "should receive save" do
        user.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should should create a flash notice" do 
        do_post
        flash[:notice].should == "Successfully created user account for #{user.puid}"
      end 
      
      it "should redirect to the admin users path" do
        do_post
        response.should redirect_to(admin_users_path)
      end
    end
    
    context "when the save fails" do                    
      it "should redirect to new template" do 
        user.stub(:save).and_return(false)            
        do_post
        response.should render_template("admin/users/new")
      end
    end 
    
    context "when the user is not an admin" do
      
      before(:each) do
        controller.stub(:admin?).and_return(false)
      end
      it "should not set the puid for non-admin" do
        user.should_not_receive(:puid=).with(params["user"]["puid"])
        do_post
      end
      
      it "should not set the user role for non-admin" do
        user.should_not_receive(:role=).with(params["user"]["role"])
        do_post
      end
    end
  end
  
  describe "GET edit" do 

    def do_get    
      get :edit, { :id => user.to_param }
    end     
          
    context "when the user is an admin they can edit user records" do
      before do                                    
        logged_in(:role? => true)
        User.stub(:find).and_return(user)     
      end             
    
      it "should receive find all" do   
        User.should_receive(:find).and_return(user)
        do_get
      end
    
      it "should assign the found users" do
        do_get
        assigns(:user).should eq(user)
      end
    
      it "should render index template" do
        do_get
        response.should render_template("admin/users/edit")
      end  
    end 
  end

  describe "PUT update" do    
    let(:params) {{ "id" => user.to_param, "user" => { "puid" => "baz", "email" => "baz@example.com", "role" => "editor" }}}    
    before(:each) do   
      controller.stub(:admin?).and_return(true) 
      User.stub(:find).and_return(user)
    end  
    
    def do_put 
      put :update, params
    end

    it "should find the record to update" do
      User.should_receive(:find).with(params["id"]).and_return(user)
      do_put
    end 
    
    it "should assign @user for the view" do  
      do_put
      assigns(:user).should eq(user)
    end
    
    it "should update the user record" do
      user.should_receive(:save).and_return(true)
      do_put
    end 
    
    it "should should set attr_accessable attributes" do
      user.should_receive(:attributes=).with(params["user"])
      do_put
    end
    
    it "should set the users role when the current_user is an admin" do
      user.should_receive(:role=).with(params["user"]["role"])
      do_put
    end
      
    it "should set a flash[:notice] message" do
      do_put
      flash[:notice].should == "Successfully updated user account for #{user.puid}"
    end         
    
    it "should redirect to INDEX" do
      do_put
      response.should redirect_to(admin_users_path)
    end                                                                       
  
    context "when update_attributes fails" do
      it "should render the edit template" do
        user.stub(:save).and_return(false)
        do_put  
        response.should render_template("admin/users/edit")
      end
    end
    
    context "it should render the admin users page for non-admin users" do
      
      before(:each) do
        controller.stub(:admin?).and_return(false)
      end
      
      it "should not set the users role when the current_user is not an admin" do
        user.should_not_receive(:role=).with(params["user"]["role"])
        do_put
      end
      
      it "should render the template for the users account" do
        do_put
        response.should render_template("admin/users/edit")
      end
    end 
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      User.stub(:find).and_return(user)
    end
    
    def do_destroy  
      delete :destroy, :id => "1"
    end
    
    it "should receive the find method and return the user to destroy" do
      User.should_receive(:find).with("1").and_return(user)
      do_destroy
    end 
    
    it "should assign the user for the view" do
      do_destroy
      assigns(:user).should eq(user)
    end    
    
    it "should destroy the user account" do
      user.should_receive(:delete).and_return(true)
      do_destroy 
    end
    
    it "should set a flash message" do
      do_destroy
      flash[:notice].should == "Successfully deleted user account for #{user.puid}"
    end
    
    it "should redirect to admin_users index action" do
      do_destroy
      response.should redirect_to(admin_users_path) 
    end
  end
end