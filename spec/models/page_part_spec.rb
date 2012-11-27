require 'spec_helper'

describe PagePart do 
  let(:user) { FactoryGirl.create(:user) }
  let(:layout) { FactoryGirl.create(:layout, :created_by => user, :updated_by => user) }
  let(:site) { FactoryGirl.create(:site) }  
  before(:each) do
    @page = FactoryGirl.create(:page, :site => site, :layout => layout, :created_by => user, :updated_by => user)
    @page_part = FactoryGirl.build(:page_part)
  end

  # -- Validations ----------------------------------------------- 
  describe "valiations" do
    it "should create a vaild page_part" do
      @page_part.should be_valid
    end
    
    it "should not be valid without a name" do
      @page_part.name = nil
      @page_part.should_not be_valid
    end
    
    it "should have a unique name when embedded" do
      pp = @page.page_parts.first
      @page.page_parts.create(:name => pp.name)
      @page.should_not be_valid
    end
    
    it "should not be valid without a filter" do
      @page_part.filter_name = nil
      @page_part.should_not be_valid
    end
  end
  
  # -- Associations -----------------------------------------------
  describe "Associations" do
    it "should be embedded in page" do
      @page_part.should be_embedded_in(:page).as_inverse_of(:page_parts)
    end
  end
  
  # -- Class Methods -----------------------------------------------
  describe "Class Methods" do
    describe "PagePart#find_by_name" do
      it "should return the page_part with the given name" do
        @page.page_parts.find_by_name(@page.page_parts.first.name).should == @page.page_parts.first
      end
    end
    
  end
end
