require 'spec_helper'

describe MediaFile do  
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user) }

  before(:each) do
    @media_file = Factory(:media_file, :site => site, :created_by => user, :updated_by => user)
  end
  
  describe "it should allow mass assignment of the fields" do
    it "should allow mass assignment of" do
      @media_file.should allow_mass_assignment_of(:name => "foobar", :description => "description", :alt_txt => "alt_txt")
    end 
  end
  
  # -- Validations  -----------------------------------------------
  describe "Validation" do
    it "should be valid" do
      @media_file.should be_valid
    end
    
    it "should not be valid without a name" do
      @media_file.name = nil
      @media_file.should_not be_valid
    end
    
    it "should not be valid without an associated site" do
      @media_file.site = nil
      @media_file.should_not be_valid
    end
  end
  
  # --  Associations -----------------------------------------------
   describe "associations" do
     it "should belong_to a site" do
       @media_file.should belong_to(:site)
     end

     it "should belong_to a user with created_by" do
       @media_file.should belong_to(:created_by).of_type(User)
     end

     it "should belong_to a user with updated_by" do
       @media_file.should belong_to(:updated_by).of_type(User)
     end
   end
end
