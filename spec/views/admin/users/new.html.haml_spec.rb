require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/new.html.haml" do
  let(:user) { stub_model(User) }
  let(:current_user) { stub_model(User, :role? => true) }
  before(:each) do
    assign(:user, user)
    assign(:current_user, current_user)
  end
  
  it "should render form title" do
    render
    rendered.should have_selector("h3", :content => "Add New User")
  end       
  
  it "should render partial _form" do
    render
    view.should render_template(:partial => "form", :locals => { :user => user, :button_label => "Create User" })
  end
end