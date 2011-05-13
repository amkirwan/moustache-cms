require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')  
require "cancan/matchers"

describe Ability do  
  let(:site) { Factory.build(:site) }
  let(:site2) { Factory.build(:site) }
  let(:admin) { Factory.build(:admin, :site => site) }
  let(:admin2) { Factory.build(:admin, :site => site2) }
  let(:editor) { Factory.build(:editor, :site => site) }
  let(:editor2) { Factory.build(:editor, :site => site2) }
  let(:layout) { Factory.build(:layout, :site => site) }
  let(:layout2) { Factory.build(:layout, :site => site2) }
  let(:page) { Factory.build(:page, :site => site, :editors => [ admin, editor ]) }
  let(:page2) { Factory.build(:page, :site => site2, :editors => [ admin2, editor2 ]) } 
  let(:admin_ability) { Ability.new(admin) }
  let(:admin_ability2) { Ability.new(admin2) }
  let(:editor_ability) { Ability.new(editor) }
  let(:editor_ability2) { Ability.new(editor2) }
  let(:user) { Factory.build(:user, :site => site) } 
  
  before(:each) do
   site.users << admin
   site2.users << admin2
  end
  
  describe "admin" do
    it "should allow the admin to manage all" do 
      admin_ability.should be_able_to(:manage, admin)
      admin_ability.should be_able_to(:manage, page)
      admin_ability.should be_able_to(:manage, layout)
      admin_ability.should be_able_to(:manage, site)
    end
    
    context "should not be able to manage any item that does not have an associated site as the admin" do
      it "should not allow the admin to manage sites they are not associatied with" do
        admin_ability.should_not be_able_to(:manage, admin2)
        admin_ability.should_not be_able_to(:manage, editor2)
        admin_ability.should_not be_able_to(:manage, page2)
        admin_ability.should_not be_able_to(:manage, layout2)
        admin_ability.should_not be_able_to(:manage, site2)
      end
    end
  end
  
  describe "editor approved actions" do
    it "should allow the user with a role of editor to list user records" do
      editor_ability.should be_able_to(:index, user)
    end
    
    it "should allow the user with a role of editor to edit their own record" do
      editor_ability.should be_able_to(:update, editor)
    end  

    it "should allow the user with a role of editor to show their own record" do
      editor_ability.should be_able_to(:show, editor)
    end
    
    it "should allow the user with a role of editor to create pages" do
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
    it "should not allow the editor to manage sites they are not associatied with" do
      editor_ability.should_not be_able_to(:manage, admin2)
      editor_ability.should_not be_able_to(:manage, editor2)
      editor_ability.should_not be_able_to(:manage, page2)
      editor_ability.should_not be_able_to(:manage, layout2)
      editor_ability.should_not be_able_to(:manage, site2)
    end
    
    describe "Site Model" do
      it "should not allow a the user as an editor to manage sites" do
        editor_ability.should_not be_able_to(:manage, site)
      end
    end
    
    describe "User Model" do
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