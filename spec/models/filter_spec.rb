# spec for Filter
require 'spec_helper'

describe Filter do   
  before(:each) do
    @filter = FactoryGirl.build(:filter)
  end

  # -- Validations -------------------------------  
  describe "validations" do
    it "should create a valid Filter" do
      @filter.should be_valid
    end
    
    it "should not be valid without a filter name" do
      @filter.name = nil
      @filter.should_not be_valid
    end
  end
  
   # -- Finder Methods -------------------------------
  describe "finder methods" do
    before(:each) do
      #Filter.filters << Filter.new(:name => "foobar")  
    end
    
    describe "Filter#all" do
      it "should find return all of the filters" do
        Filter.all.should have(4).items
      end
    
      it "should return an array of Filter objects" do
        Filter.all.first.should be_a(Filter)
      end
    end
  
    describe "Filter#find" do
      it "should have the name of markdown for the returned filter" do
        Filter.find("markdown").name.should == "markdown"
      end
    end
  
    describe "Filter#find_by_name" do
      it "should have the name of markdown for the returned filter" do
        Filter.find_by_name("markdown").name.should == "markdown"
      end
    end
  end
end
