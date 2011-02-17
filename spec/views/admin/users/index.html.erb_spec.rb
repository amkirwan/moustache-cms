require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/index.html.haml" do   
  let(:users) { [mock_model("User", :username => "foo", :role => "admin")] } 
  before(:each) do 
    assign(:users, users) 
  end   
  it "should display the users name" do
    render 
    rendered.should contain("foo")
  end                             
  
  it "should display the users role" do
    render
    rendered.should contain("admin")
  end  
  
  it "should render a delete button to delete the user" do
    render  
    users.each do |user|
      render.should have_selector("form", 
        :method => "post", :action => admin_user_path(user)
      ) do |form|
        form.should have_selector("input", :value => "delete") 
      end 
    end
  end  
  
  it "should render a new user link" do
    render
    rendered.should have_selector("a", :href => new_admin_user_path)
    rendered.should contain("New User")
  end
end  

