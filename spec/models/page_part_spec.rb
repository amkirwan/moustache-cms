require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe PagePart do   
  before(:each) do
    @page_part = Factory.build(:page_part)
  end
  
  context "valiations" do
    it "should create a vaild page_part" do
      @page_part.should be_valid
    end
    
    it "should not be valid without a name" do
      @page_part.name = nil
      @page_part.should_not be_valid
    end
    
    it "should have a unique name when embedded" do
      page = Page.make!
      pp = page.page_parts.first
      page.page_parts.create(:name => pp.name)
      page.should_not be_valid
    end
  end
  
  context "associations" do
    it "should be embedded in page" do
      @page_part.should be_embedded_in(:page).as_inverse_of(:page_parts)
    end
  end
end