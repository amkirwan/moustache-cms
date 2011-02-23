require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/edit.html.haml" do  
  before(:each) do
    @user = assign(:user, stub_model(User))
    @current_user = assign(:current_user, stub_model(User, :role? => true))
  end  
   
  it "should render form title" do  
    @user.stub(:username => "foobar")
    render
    rendered.should have_selector("h3", :content => "User Account for #{@user.username}")
  end   
  
  it "should render partial _form" do
    render
    view.should render_template(:partial => "form", :locals => { :user => @user, :button_label => "Update User" })
  end
end