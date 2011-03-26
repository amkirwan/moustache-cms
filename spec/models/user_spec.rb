require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe User do   
  before(:each) do
    @user = Factory(:user)
  end 
  
  context "mass assignment" do
    it "should protect against mass assignment of puid and role" do
      user = User.new(:puid => "ak730", :role => "admin")
      user.role.should be_nil
      user.puid.should be_nil
    end
    
    it "should not allow mass assignment of" do
      @user.should_not allow_mass_assignment_of(:puid => "foobar", :username => "foobar", :role => "bar")
    end
    
    it "should allow mass assignment of" do
      @user.should allow_mass_assignment_of(:firstname => "x", :lastname => "x", :email => "foobar@example.com")
    end
  end
  
  context "before_validation set page filter if it isn't set" do
    it "should make page_ids array unique" do
      @user.page_ids = [ "4d7cd4617353202ab6000065", "5d7cd4617353202ab6000065", "4d7cd4617353202ab6000065", "4d7cd4617353202ab6000065"]
      @user.save
      @user.page_ids.count.should == 2
    end
  end
  
  context "validations" do
    it "should create a valid user with valid attributes" do
      @user.should be_valid
    end
  
    it "should not be valid without a Partners ID" do
     @user.puid = nil
     @user.should_not be_valid
    end  
  
    it "should not be valid without a email" do
      @user.email = nil
      @user.should_not be_valid
    end   
  
    it "should not be valid without a role" do
      @user.role = nil
      @user.should_not be_valid
    end 
  
    it "should not be valid with duplicate pid" do  
      User.make(:puid => "#{@user.puid}").should_not be_valid
    end
  
    it "should not be valid with duplicat email addresses" do
      User.make(:email => "#{@user.email}").should_not be_valid
    end      
  
    it "should not be valid without a correctly formated email address" do
      User.make(:email => "abcdefg").should_not be_valid
    end
    
    it "should not be valid with a puid < 3" do
      User.make(:puid => "ab").should_not be_valid
    end 
  end
  
  context "role?" do
    it "should return true when the user role equals the base role" do
      @user.role = "admin"
      @user.role?(:admin).should == true
    end 
    
    it "should return true when the user role is greater than the base role" do
      @user.role = "admin"
      @user.role?(:editor).should == true
    end    
    
    it "should return true when the user role is greater than or equal to the base role" do
     @user.role = "editor"
     @user.role?(:editor).should == true
    end
    
    it "should return false when the user role is less than the base role" do
      @user.role = "editor"
      @user.role?(:admin).should == false
    end
  end
  
  context "associations" do
    it "should reference many layouts created" do
      @user.should reference_many(:layouts_created).of_type(Layout)
    end
    
    it "should reference many layouts updated" do
      @user.should reference_many(:layouts_updated).of_type(Layout)
    end
    
    it "should reference many pages created" do
      @user.should reference_many(:pages_created).of_type(Page)
    end
    
    it "should reference many pages updated" do
      @user.should reference_many(:pages_updated).of_type(Page)
    end
    
    it "should have many editors" do
      @user.should reference_and_be_referenced_in_many(:pages).of_type(Page)
    end
  end
  
  context "callbacks" do
    context "before validation it should check that the page_ids are unique" do
      it "should do something" do
        @user.page_ids = [BSON::ObjectId('4d7fe2397353202ab60000e9'), BSON::ObjectId('4d7fe2397353202ab60000e9')]
        @user.save
        @user.page_ids.count.should == 1
      end
    end
    
    context "it should lower the fields before saving" do
      it "should make the puid downcase" do
        @user.puid = "FOOBAR"
        @user.save
        @user.puid.should == "foobar"
      end
    
      it "should make the email downcase" do
        @user.email = "FOOBAR@EXAMPLE.Com"
        @user.save
        @user.email.should == "foobar@example.com"
      end
    end
  
    context "after save set_username" do
      it "should set the username to the puid value" do
        @user.puid.should == @user.username
      end
    end
  end
end