require 'spec_helper'

describe Author do
  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user, :site => site) }

  before(:each) do
    @author = FactoryGirl.create(:author, :site => site, :firstname => "Anthony", :middlename => "Michael", :lastname => "Kirwan")
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

    it "should has_and_belong_to_many articles" do
      @author.should have_and_belong_to_many(:articles)
    end

  end

  # -- Validations  -----------------------------------------------
  describe "validations" do
    it "should be valid" do
      @author.should be_valid    
    end

    it "should not be valid without a firstname" do
      @author.firstname = nil
      @author.should_not be_valid 
    end

    it "should not be valid without a lastname" do
      @author.lastname = nil
      @author.should_not be_valid
    end

    it "should not be valid without a image" do
      @author.remove_image!
      @author.should_not be_valid
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

    describe "#md5" do
      it "should calculate an md5 for the author image" do
        pending "calculated in lib/calc_md5 this version just changes the path for the author image"
      end
    end

  end
end
