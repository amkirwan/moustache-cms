require 'spec_helper'

describe Admin::UsersController do
  
  before(:each) do
    login_admin
  end

  describe "GET index" do
    def do_get     
      get :index
    end

    let(:users) { [mock_model("User", :username => "foo", :role => "admin"),
                  mock_model("User", :username => "bar", :role => "editor")] } 
    
    before(:each) do
      User.stub(:accessible_by).and_return(users)
      users.stub(:where).and_return(users)
    end
    
    it "should receive accessible_by" do
      User.should_receive(:accessible_by).and_return(users)
      do_get
    end
    
    
    it "should assign the found users" do
      do_get
      assigns(:users).should eq(users)
    end

    it "should only show the users for the site" do
      users.should_receive(:where).with(:site_id => @current_admin_user.site_id)
      do_get  
    end
  
    it "should render index template" do
      do_get
      response.should render_template("admin/users/index")
    end  
  end   
  
  describe "GET show" do
    let(:params) {{ :id => "1" }}
    
    before(:each) do
      User.stub(:find).and_return(@admin_user)
    end
    
    def do_get
      get :show, :id => "1"
    end
        
    it "should should receive find" do
      User.should_receive(:find).with(params[:id]).and_return(@admin_user)
      do_get
    end
    
    it "should assign @user for the view" do
      do_get
      assigns(:user).should eq(@admin_user)
    end
 
    it "should render the EDIT template" do
      do_get
      response.should render_template("admin/users/edit")
    end
  end
  
  describe "GET new" do        
    before(:each) do 
      @user = FactoryGirl.build(:user)
      User.stub(:new).and_return(@user)   
    end
    
    def do_get     
      get :new
    end  
    
    it "should receive new the new and return a new user" do   
      User.should_receive(:new).and_return(@user)
      do_get
    end
  
    it "should assign the found user" do
      do_get
      assigns(:user).should eq(@user)
    end
  
    it "should render new template" do
      do_get
      response.should render_template("admin/users/new")
    end
  end     
  
  
  describe "POST create" do 
    let(:params) {{ "user" => { "username" => "foobar", "firstname" => "foo", "lastname" => "bar", "email" => "foobar@example.com", "role" => "admin" }}}
    
    before(:each) do 
      @user = FactoryGirl.build(:user)
      @user.stub(:save).and_return(true)
      controller.stub(:admin?).and_return(true)
      User.stub(:new).and_return(@user)
    end  
    
    def do_post       
      post :create, params
    end  
              
    it "should create a new user" do
      User.should_receive(:new).with(params["user"]).and_return(@user)
      do_post 
    end 

    it "should assign @user" do
      do_post
      assigns(:user).should eq(@user)                                                              
    end
    
    it "should assign the username value" do
      @user.should_receive(:username=).with(params["user"]["username"])
      do_post
    end

    it "should assign the role value" do
      @user.should_receive(:role=).with(params["user"]["role"])
      do_post
    end
    
    it "should assign the current_site" do
      @user.should_receive(:site=)
      do_post
    end
    
    it "should assign the role value" do
      @user.should_receive(:role=).with(params["user"]["role"])
      do_post
    end
    
    context "when it saves the new user successfully" do  
      
      it "should receive save" do
        @user.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should should create a flash notice" do 
        do_post
        flash[:notice].should == "Successfully created the user profile for #{@admin_user.full_name}"
      end 
      
      it "should redirect to the admin users path" do
        do_post
        response.should redirect_to(admin_users_path)
      end
    end
    
    context "when the save fails" do                    
      it "should redirect to new template" do 
        @user.stub(:save).and_return(false)            
        @user.stub(:errors => { :user => "user errors" })
        do_post
        response.should render_template("admin/users/new")
      end
    end 
  end
  
  describe "GET edit" do 
    def do_get    
      get :edit, { :id => @admin_user.to_param }
    end     
          
    before do                                    
      User.stub(:find).and_return(@admin_user)     
    end             
  
    it "should receive find all" do   
      User.should_receive(:find).and_return(@admin_user)
      do_get
    end
  
    it "should assign the found users" do
      do_get
      assigns(:user).should eq(@admin_user)
    end
  
    it "should render the user to edit" do
      do_get
      response.should render_template("admin/users/edit")
    end  
  end

  describe "PUT update" do    
    let(:params) { { "id" => @admin_user.to_param, "user" => { "username" => "baz", "email" => "baz@example.com", "role" => "editor" }} }
    before(:each) do   
      controller.stub(:admin?).and_return(true) 
      User.stub(:find).and_return(@admin_user)
    end  
    
    def do_put(put_params=params)
      put :update, put_params
    end

    it "should find the record to update" do
      User.should_receive(:find).with(params["id"]).and_return(@admin_user)
      do_put
    end 
    
    it "should assign @user for the view" do  
      do_put
      assigns(:user).should eq(@admin_user)
    end
    
    it "should set the users role when the current_admin_user is an admin" do
      @admin_user.should_receive(:role=).with(params["user"]["role"])
      do_put
    end
    
    it "should should set attr_accessable attributes" do
      @admin_user.should_receive(:update_without_password).with(params["user"])
      do_put
    end
      
    it "should set a flash[:notice] message" do
      do_put
      flash[:notice].should == "Successfully updated the user profile for #{@admin_user.full_name}"
    end         
    
    it "should redirect to list of users" do
      do_put
      response.should redirect_to(admin_users_path)
    end                                                                       
    context "when update_attributes fails" do
      it "should render the edit template" do
        @admin_user.stub(:update_without_password).and_return(false)
        @admin_user.stub(:errors => { :user => "user errors" })
        do_put  
        response.should render_template("admin/users/edit")
      end
    end
  end
  
  describe "DELETE destroy" do   
    before(:each) do
      User.stub(:find).and_return(@admin_user)
      Site.stub(:first).and_return(mock_model(Site))
    end
    
    def do_destroy  
      delete :destroy, :id => "1"
    end
    
    it "should receive the find method and return the user to destroy" do
      User.should_receive(:find).with("1").and_return(@admin_user)
      do_destroy
    end 
    
    it "should assign the user for the view" do
      do_destroy
      assigns(:user).should == @admin_user
    end    
    
    it "should delete the user account" do
      @admin_user.should_receive(:delete).and_return(true)
      do_destroy 
    end
    
    context "when destroying the current logged in user account" do
      before(:each) do
        controller.stub(:current_admin_user?).and_return(true)
      end

      it "should destroy the current session" do
        controller.should_receive(:reset_session)
        do_destroy
      end
      
      it "should redirecto to the index page of the cms" do
        do_destroy
        response.should redirect_to("http://test.host/admin/sign_in")
      end
    end
    
    context "when destroying another users record" do
      before(:each) do
        controller.stub(:current_admin_user?).and_return(false)
      end
      
      it "should set a flash message" do
        do_destroy
        flash[:notice].should == "Successfully deleted the user profile for #{@admin_user.full_name}"
      end

      it "should redirect to admin_users index action" do
        do_destroy
        response.should redirect_to(admin_users_path) 
      end
    end
  end
end
