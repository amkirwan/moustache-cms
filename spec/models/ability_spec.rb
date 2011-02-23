require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')  
require "cancan/matchers"

describe Ability do  
  let(:admin) { User.make(:admin) }
  let(:editor) { User.make(:editor) }  
  let(:admin_ability) { Ability.new(admin) }
  let(:editor_ability) { Ability.new(editor) }
  
  it "should allow the admin to manage all" do
    admin_ability.should be_able_to(:manage, admin)
  end
   
  it "should allow the user with a role of editor to edit their own record" do
    editor_ability.should be_able_to(:edit, editor)
  end  
  
  it "should not allow the user with a role of editor to delete their record" do
    editor_ability.should_not be_able_to(:destroy, editor)
  end 
  
  it "should not allow the user with a role of editor to read records" do
    editor_ability.should_not be_able_to(:read, admin)
  end  
  
  it "should not allow the user with a role of editor to delete another users record" do
    editor_ability.should_not be_able_to(:destory, admin)
  end
  
  it "should not allow the user with a role of editor to create a new user record" do
    editor_ability.should_not be_able_to(:new, User.make)
  end
  
  it "should not allow the user with a role of editor  to edit other user records" do
    editor_ability.should_not be_able_to(:edit, admin)
  end    
end