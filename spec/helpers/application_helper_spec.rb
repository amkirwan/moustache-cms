require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')      

describe "ApplicationHelper" do 
  describe "admin? method" do
    it "should receive admin? method and render the content when the user is an admin" do
      user = stub_model(User, :role? => "admin")    
      assign(:current_admin_user, user) 
      helper.admin?.should == true
    end  
    
    it "should receive admin? method and not render the content when the user is not an admin" do
      user = stub_model(User, :role? => "editor")    
      assign(:current_admin_user, user) 
      helper.admin?.should == true
    end 
  end  
end