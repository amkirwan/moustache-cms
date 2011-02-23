require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')  
require "cancan/matchers"

describe Ability do  
  let(:admin) { User.make(:admin) }
  let(:editor) { User.make(:editor) }
  let(:user) { User.make }  
  let(:admin_ability) { Ability.new(admin) }
  let(:editor_ability) { Ability.new(editor) }
  
  it "should allow the admin to manage all" do
    admin_ability.should be_able_to(:manage, admin)
  end
  
  context "editor approved actions" do
    it "should allow the user with a role of editor to edit their own record" do
      editor_ability.should be_able_to(:update, editor)
    end  

    it "should allow the user with a role of editor to show their own record" do
      editor_ability.should be_able_to(:show, editor)
    end
  end
   
  context "editor not approved actions" do
    it "should not allow the user with a role of editor to run the index action" do
      editor_ability.should_not be_able_to(:index, user)
    end

    it "should not allow the user with a role of editor to read other users records" do
      editor_ability.should_not be_able_to(:read, user)
    end

    it "should not allow the user with a role of editor to delete their record" do
      editor_ability.should_not be_able_to(:destroy, editor)
    end 

    it "should not allow the user with a role of editor to create a new user record" do
      editor_ability.should_not be_able_to(:new, User.make)
    end

    it "should not allow the user with a role of editor to edit other user records" do
      editor_ability.should_not be_able_to(:update, user)
    end
  end    
end