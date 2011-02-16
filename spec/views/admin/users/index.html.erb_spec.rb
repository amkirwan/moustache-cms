require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper') 
describe "admin/users/index.html.haml" do      
  
  it "should display the list of users that are admins and editors" do
    assign(:users, [mock_model("User", :username => "foo", :role => "admin")])
    render 
    rendered.should contain("foo")
    rendered.should contain("admin")
  end
end  