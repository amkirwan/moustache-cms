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
    
    describe "different filters groups" do
      it "should find return all of the filters" do
        Filter.all.should have(5).items
      end

      it "all filter names" do
        filter_names = Filter.all.collect { |f| f.name }
        filter_names.should == %w{html markdown textile haml javascript}
      end

      it "should find return page filters" do
        Filter.page_filters.should have(4).items
      end

      it "page filter names" do
        filter_names = Filter.page_filters.collect { |f| f.name }
        filter_names.should == %w{html markdown textile javascript}
      end

      it "should find return article_filters" do
        Filter.article_filters.should have(3).items
      end

      it "page filter names" do
        filter_names = Filter.article_filters.collect { |f| f.name }
        filter_names.should == %w{markdown textile html}
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
