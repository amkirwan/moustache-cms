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
      @user.should allow_mass_assignment_of(:firstname => "foobar", :lastname => "foobar", :email => "foobar@example.com")
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
end