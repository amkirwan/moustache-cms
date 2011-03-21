# spec for CurrentState
require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe CurrentState do   
  
  context "validations" do
    before(:each) do
      @current_state = CurrentState.make
    end
    
    it "should create a valid CurrentState with valid attributes" do
      @current_state.should be_valid
    end
  
    it "should not be valid without a current_state name" do
     @current_state.name = nil
     @current_state.should_not be_valid
    end
  end
  
  context "CurrentState#all" do
    it "should return all the statuses" do
      CurrentState.all.count.should == 2
    end
    
    it "should return objects with class CurrentState" do
      CurrentState.all.first.class == "CurrentState"
    end
  end
  
  context "CurrentState#find" do
    before(:each) do
      CurrentState.statuses << CurrentState.new(:name => "foobar")  
    end
    
    it "should return the CurrentState object" do
      CurrentState.find("foobar").class == "CurrentState"
    end
    
    it "should have the name of foobar" do
      CurrentState.find("foobar").name == "foobar"
    end
  end
  
  context "CurrentState#find_by_name" do
    before(:each) do
      CurrentState.statuses << CurrentState.new(:name => "foobar")
    end
    
    it "should return the CurrentState with the name given" do
      CurrentState.find_by_name("foobar").class == "CurrentState"
    end
    
    it "should return the CurrentState with the name given" do
      CurrentState.find_by_name("foobar").name == "foobar"
    end
  end
  
  context "association" do
    it "should be embbeded in page" do
      should be_embedded_in(:page).as_inverse_of(:current_state)
    end
  end
end