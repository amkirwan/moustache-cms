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

    it "should has_and_belong_to_many articles" do
      @author.should have_and_belong_to_many(:articles)
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

    describe "#articles" do
      it "should return all the articles the author has created" do
        article = Factory.build(:article, :authors => [user])
        article_collection = Factory(:article_collection, :site => site, :articles => [article])
        puts "*"*10 + "#{@author.articles}"
        @author.articles.first.should == article 
      end

      it "should return no artilces for the author if none have been created by the author" do
        @author.articles.should be_empty
      end
    end
  end


end
