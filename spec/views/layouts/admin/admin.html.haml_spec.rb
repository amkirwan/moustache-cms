require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "layouts/admin/admin.html.haml" do
  let(:user) { mock_model(User).as_null_object }  
  before(:each) do  
    ability_init
  end          
  
  it "should display Users link when the user has the correct roles to manage them" do 
    @ability.can :manage, User     
    render
    rendered.should contain("Users")
  end
  
  it "should not display the Users link when the user does not have the role to manage them" do
    @ability.can :edit, User  
    render
    rendered.should_not contain("Users") 
    rendered.should contain("Persona")
  end
end