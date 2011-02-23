require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/new.html.haml" do
  before(:each) do
    @user = assign(:user, stub_model(User))
    @current_user = assign(:current_user, stub_model(User, :role? => true))
  end
  
  it "should render form title" do
    render
    rendered.should have_selector("h3", :content => "Add New User")
  end       
  
  it "should render partial _form" do
    render
    view.should render_template(:partial => "form", :locals => { :user => @user, :button_label => "Create User" })
  end
end