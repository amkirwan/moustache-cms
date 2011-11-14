# users index spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/index.html.haml" do   
  let(:users) { [stub_model(User, :puid => "foo", :role => "admin")] }
  let(:current_admin_user) { stub_model(User, :role? => true) }
   
  before(:each) do 
    assign(:users, users) 
    assign(:current_admin_user, current_admin_user)
    controller.stub(:current_admin_user).and_return(current_admin_user)
  end     
  
  it "should render a edit link" do
    render 
    users.each do |user|
      rendered.should have_selector("li#foo") do |li|
        li.should have_selector("a", :content => user.puid, :href => edit_admin_user_path(user))
      end
    end  
  end                          
  
  it "should display the users role" do
    render
    rendered.should contain("admin")
  end 
  
  context "when the user has the ability to destroy user records" do
    it "should render a delete button" do  
      render  
      users.each do |user|
        render.should have_selector("a", :content => "Delete", :href => admin_user_path(user))
      end
    end 
  end 
  
  context "when the user does not have the ability to destroy the user records" do
    it "should not render a delete button" do
      controller.stub(:current_admin_user).and_return(stub_model(User, :role? => false))
      render
      users.each do |user|
        render.should_not have_selector("a", :content => "Delete", :href => admin_user_path(user))
      end  
    end
  end
  
  it "should render a new user link" do
    render
    rendered.should have_selector("a", :href => new_admin_user_path)
    rendered.should contain("New User")
  end
end  

