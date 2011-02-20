require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/edit.html.haml" do  
  let(:user) { mock_model(User).as_null_object } 
  
  before(:each) do 
    assign(:user, user) 
  end
   
  it "should render a form to edit an exsisting record" do
    render
    rendered.should have_selector("form", :method => "post", :action => admin_users_path) do |form|
      form.should have_selector("input", :type => "submit", :value => "Update User")   
    end
  end                                                                                   
  
  it "should show a field to update the username" do 
    user.stub(:username).and_return "foobar"
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "user[username]", :value => "foobar")
    end
  end                                          
  
  it "should show a field to enter an email address" do  
    user.stub(:email).and_return("foobar@example.com")
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "email", :name => "user[email]", :value => "foobar@example.com")
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