require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/new.html.haml" do  
  let(:user) { mock_model(User).as_null_object.as_new_record } 
  
  before(:each) do 
    assign(:user, user) 
  end
   
  it "should render a form to create a new user" do
    render
    rendered.should have_selector("form", :method => "post", :action => admin_users_path) do |form|
      form.should have_selector("input", :type => "submit", :value => "Create User")   
    end
  end                                                                                   
  
  it "should show a field to enter the username" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "user[username]")
    end
  end                                          
  
  it "should show a field to enter an email address" do 
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "email", :name => "user[email]")
    end
  end
  
  it "should show radio button to set user role" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
      form.should have_selector("input", :type => "radio", :name => "user[role]", :value => "admin")   
    end
  end
end