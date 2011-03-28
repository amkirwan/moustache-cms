require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe PageType do   
  before(:each) do
    @page_type = Factory.build(:page_type)
  end
  
  # -- Validations -------------------------------
  context "validations" do
    it "should create a valid page_type" do
      @page_type.should be_valid
    end
    
    it "should not be valid without a name" do
      @page_type.name = nil
      @page_type.should_not be_valid
    end
  end
  
  # -- Finder methods -------------------------------
  describe "finder methods" do
    before(:each) do
      PageType.page_types << PageType.new(:name => "foobar")
    end
    
    describe "PageType#all method" do
      it "should return all the page types" do
        PageType.all.should have(4).items
      end
      
      it "should return an array of PageType objects" do
        PageType.all.first.should be_a(PageType)
      end
    end
    
    describe "PageType#find method" do
      it "should return the page_type" do
        PageType.find("foobar").name.should == "foobar"
      end
    end
    
    describe "PageType#find_by_name" do
      it "should return the page_type" do
        PageType.find_by_name("foobar").name.should == "foobar"
      end 
    end
  end
end