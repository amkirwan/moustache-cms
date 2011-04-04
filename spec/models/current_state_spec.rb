# spec for CurrentState
require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe CurrentState do  
  before(:each) do
    @current_state = Factory.build(:current_state)
  end
   
  # -- Validations -------------------------------
  context "validations" do    
    it "should create a valid CurrentState with valid attributes" do
      @current_state.should be_valid
    end
  
    it "should not be valid without a current_state name" do
     @current_state.name = nil
     @current_state.should_not be_valid
    end
  end
  
  describe "association" do
    it "should be embbeded in page" do
      should be_embedded_in(:page).as_inverse_of(:current_state)
    end
  end
  
  # -- Class Finder Methods -------------------------------
  describe "finder methods" do
    before(:each) do
      CurrentState.statuses << CurrentState.new(:name => "foobar")  
    end

    context "CurrentState#all" do
      it "should return all the statuses" do
        CurrentState.all.count.should == 3
      end
    
      it "should return objects with class CurrentState" do
         CurrentState.all.first.should be_a(CurrentState)
      end
    end
  
    context "CurrentState#find" do
      it "should have the name of foobar" do
        CurrentState.find("foobar").name.should == "foobar"
      end
    end
  
    context "CurrentState#find_by_name" do
      it "should return the CurrentState with the name given" do
        CurrentState.find_by_name("foobar").name.should == "foobar"
      end
    end
  end

  #-- Instance Methods --------------------------------------------------
  describe "Instance Methods" do
    describe "#published" do
      it "should return true when the current_state.name is published" do
        @current_state.published?.should be_true
      end
     
      it "should return false when the current_state.name is not published" do
        @current_state.name = "draft"
        @current_state.published?.should be_false
      end
    end  
    
    describe "#draft" do
      it "should return true when the current_state.name is draft" do
        @current_state.name = "draft"
        @current_state.draft?.should be_true
      end
      
      it "should return false when the current_state.name is not draft" do
        @current_state.draft?.should be_false
      end
    end
  end
end




