require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe User do   
  before(:each) do
    @user = User.make!
  end 
  
  context "mass assignment" do
    it "should protect against mass assignment of puid and role" do
      user = User.new(:puid => "ak730", :role => "admin")
      user.role.should be_nil
      user.puid.should be_nil
    end
    
    it "should not allow mass assignment of" do
      @user.should_not allow_mass_assignment_of(:puid => "foobar", :role => "bar")
    end
    
    it "should allow mass assignment of" do
      @user.should allow_mass_assignment_of(:username => "foobar", :email => "foobar@example.com")
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
    
    it "should not be vailid without a username" do
      @user.username = nil
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
    
    it "should not be valid with a duplicate username" do
      User.make(:username => "#{@user.username}").should_not be_valid
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
  
    it "should not be valid with a username length of < 3" do
      User.make(:username => "ab").should_not be_valid
    end
  
    it "should not be valid with a username length of > 20" do
      User.make(:username => "ab"*10 + "c").should_not be_valid
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
end