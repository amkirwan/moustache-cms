require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')  
require "cancan/matchers"

describe Ability do  
  let(:admin) { Factory.build(:admin) }
  let(:editor) { Factory.build(:editor) }
  let(:page) { Factory.build(:page, :editors => [ admin, editor ]) }
  let(:user) { Factory.build(:user) }  
  let(:site) { Factory.build(:site)}
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
    
    it "should allow the user with ra role of editor to create pages" do
      editor_ability.should be_able_to(:create, page)
    end
    
    it "should allow the user with a role of editor to index action" do
      editor_ability.should be_able_to(:index, page)
    end
    
    it "should allow the user with a role of editor to show pages they are an editor for" do
      editor_ability.should be_able_to(:show, page)
    end
    
    it "should allow the user with a role of editor to update pages they have editor rights for" do
      editor_ability.should be_able_to(:update, page)
    end
    
    it "should allow the user with a role of editor to destroy pages they have editor rights for" do
      editor_ability.should be_able_to(:destroy, page)
    end
  end
   
  context "editor not approved actions" do
    describe "Site Model" do
      it "should not allow a the user as an editor to manage sites" do
        editor_ability.should_not be_able_to(:manage, site)
      end
    end
    
    describe "User Model" do
      it "should not allow the user with a role of editor to list user records" do
        editor_ability.should_not be_able_to(:index, user)
      end

      it "should not allow the user with a role of editor to read other users records" do
        editor_ability.should_not be_able_to(:read, user)
      end

      it "should not allow the user with a role of editor to delete their record" do
        editor_ability.should_not be_able_to(:destroy, editor)
      end 

      it "should not allow the user with a role of editor to create a new user record" do
        editor_ability.should_not be_able_to(:new, Factory.build(:user))
      end

      it "should not allow the user with a role of editor to edit other user records" do
        editor_ability.should_not be_able_to(:update, user)
      end    
    end

    describe "Page Model" do
      it "should not allow the user with a role of editor to read a page they are not an editor for" do
        editor_ability.should_not be_able_to(:read, Factory.build(:page))
      end

      it "should not allow the user with a role of editor to update a page they are not an editor for" do
        editor_ability.should_not be_able_to(:update, Factory.build(:page))
      end

      it "should not allow the user with a role of editor to destroy pages they are not an editor for" do
        editor_ability.should_not be_able_to(:destroy, Factory.build(:page))
      end
    end
  end    
end