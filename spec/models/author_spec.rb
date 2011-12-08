require 'spec_helper'

describe Author do
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }

  before(:each) do
    @author = Factory(:author, :site => site, :firstname => "Anthony", :middlename => "Michael", :lastname => "Kirwan")
  end

  # -- Associations ---
  describe "Author Associations" do
    it "should belong to a site" do
      @author.should belong_to(:site)
    end

    it "should belong_to a user with created_by" do
      @author.should belong_to(:created_by).of_type(User)
    end
    
    it "should belong_to a user with updated_by" do
      @author.should belong_to(:updated_by).of_type(User)
    end
  end

  # -- Before Save ---
  describe "Before Save" do
    it "should remove any extra white space" do
      @author.firstname = "     Anthony   "
      @author.save
      @author.firstname.should == "Anthony"
    end
  end

  # -- Instance Methods ---
  describe "Instance Methods" do
    describe "#full_name" do
      it "should return the authors full_name" do
        @author.full_name == "Anthony Michael Kirwan"
      end
    end
  end

end
