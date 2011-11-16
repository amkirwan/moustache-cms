require 'spec_helper'

describe Snippet do  
  let(:site) { Factory(:site) } 
  let(:user) { Factory(:user, :site_id => site.id) }
  before(:each) do
    @snippet = Factory(:snippet, :site => site, :created_by_id => user.id, :updated_by_id => user.id)
  end 
  
  # -- Mass Assignment ---
  context "mass assignment" do
    it "should protect against mass assignment of username and role" do
      snippet = Snippet.new(:created_by_id => "ak730", :updated_by_id => "ak730")
      snippet.created_by_id.should be_nil
      snippet.updated_by_id.should be_nil
    end
    
    it "should allow mass assignment of" do
      @snippet.should allow_mass_assignment_of(:name => "foobar", :content => "content", :filter_name => "markdown")
    end
  end
  
  
  # -- Associations ---
  context "Associations" do          
    it "should belong to a site" do
      @snippet.should belong_to(:site)
    end                               
    
    it "should reference a user with created_by" do
      @snippet.should belong_to(:created_by).of_type(User)
    end
    
    it "should reference a user with updated_by" do
      @snippet.should belong_to(:updated_by).of_type(User)
    end
  end                      
  
  # -- Validations ---
  context "Validations" do
    it "should be a valid snippet" do
      @snippet.should be_valid
    end                       
    
    it "should not be valid without a name" do
      @snippet.name = nil
      @snippet.should_not be_valid
    end        
    
    it "should not be valid without a unique name" do 
      Factory.build(:snippet, :name => @snippet.name, :site_id => site.id).should_not be_valid
    end
    
    it "should not be valid without a filter" do
      @snippet.filter_name = nil
      @snippet.should_not be_valid
    end
    
    it "should not be valid without a created_by" do
      @snippet.created_by_id = nil
      @snippet.should_not be_valid
    end
    
    it "should not be valid without a updated_by" do
      @snippet.updated_by_id = nil
      @snippet.should_not be_valid
    end
  end  
  
  # --  Scopes -----------------------------------------------------
  describe "Scopes" do
    describe "Snippet#find_by_site_and_name(site, name)" do
      it "should return the snippet a mongoid criteria" do
        Snippet.find_by_site_and_name(site, @snippet.name).should be_an_instance_of(Mongoid::Criteria)
      end
      
      it "should return the snippet with the name" do
        Snippet.find_by_site_and_name(site, @snippet.name).first.should == @snippet
      end
    end
  end
end















