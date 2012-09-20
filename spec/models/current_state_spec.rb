# spec for CurrentState
require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

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

    describe "#formatted_date_time" do
      it "should return the date formatted with the date" do
        @current_state.time = "2012-08-08 15:08:44 -0400"
        @current_state.formatted_date_time.should == "8 Aug 2012 at  3pm" 
      end
    end

    describe "#formatted_date" do
      it "should return the date formatted" do
        @current_state.time = "2012-08-08 15:08:44 -0400"
        @current_state.formatted_date.should == "8 Aug 2012"
      end
    end

    describe "#formatted_time" do
      it "should return the time formatted" do
        @current_state.time = "2012-08-08 15:08:44 -0400"
        @current_state.formatted_time.should == "3pm"
      end
    end

    describe "#formatted_time_zone" do
      it "should return the time zone" do
        @current_state.time = "2012-08-08 15:08:44 -0400"
        @current_state.formatted_time_zone.should == "EDT"
      end
    end
  end
end
