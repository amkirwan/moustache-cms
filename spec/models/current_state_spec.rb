# spec for CurrentState
require 'spec_helper'

describe CurrentState do  
  before(:each) do
    @current_state = FactoryGirl.build(:current_state)
  end
   
  # -- Validations -------------------------------
  context "validations" do    
    it { @current_state.should be_valid }
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:name) }
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
    
    describe "#published_on" do
      it "should return the DateTime if published" do
        @current_state.published_on.should == @current_state.time
      end
      
      it "should not return DateTime if published is false" do
        @current_state.name = "draft"
        @current_state.published_on.should be_nil
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
