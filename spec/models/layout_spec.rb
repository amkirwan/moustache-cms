# spec for Layout Model
require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe User do   
  before(:each) do
    @layout = Layout.make!
  end
  
  context "mass assignment" do
    it "should protect against mass assignment of created_by and updated_by" do
      layout = Layout.new(:updated_by => mock_model("User"), :created_by => mock_model("User"))
      layout.created_by.should be_nil
      layout.updated_by.should be_nil
    end
    
    it "should not allow mass assignment of" do
      @layout.should_not allow_mass_assignment_of(:created_by => mock_model("User"), :updated_by => mock_model("User"))
    end
    
    it "should allow mass assignment of" do
      @layout.should allow_mass_assignment_of(:name => "foobar", :content => "Hello,World!")
    end
  end
  
  context "validations" do
    it "should create a valid user with valid attributes" do
      @layout.should be_valid
    end
    
    it "should not be valid without a layout name" do
     @layout.name = nil
     @layout.should_not be_valid
    end
    
    it "should not be valid without a unique layout name" do
      Layout.make(:name => "#{@layout.name}").should_not be_valid
    end
    
    it "should not be valid without content" do
      @layout.content = nil
      @layout.should_not be_valid
    end
    
    it "should not be valid without createb_by" do
      @layout.created_by = nil
      @layout.should_not be_valid
    end
    
    it "should validate associated user instance in created_by" do
      @layout.created_by = User.make(:username => nil)
      @layout.should_not be_valid
    end
    
    it "should not be valid without updated_by" do
      @layout.updated_by = nil
      @layout.should_not be_valid
    end
    
    it "should validate associated user instance in updated_by" do
      @layout.updated_by = User.make(:username => nil)
      @layout.should_not be_valid
    end
    
  end
end