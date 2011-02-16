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
      let(:user) { User.make(:admin) }   
                
      before do                                    
        stub_current_user(user)
        User.stub(:all).and_return(users)     
      end             
    
      it "should receive the index action" do
        controller.should_receive(:index)
        do_get
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
      let(:user) {User.make(:editor)} 
      before do
        stub_current_user(user)  
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
end
