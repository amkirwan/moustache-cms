require 'spec_helper'

describe "ArticleCollection" do
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user) }
  let(:article) { Factory.build(:article, :site => site, :created_by => user, :updated_by => user) }

  before(:each) do
    @article_collection = Factory(:article_collection, :articles => [article], :site => site, :created_by => user, :updated_by => user)           
  end

  # --  Associations ---- 
  describe "associations" do
    it "should belong_to a site" do
      @article_collection.should belong_to(:site)
    end

    it "should belong_to a user with created_by" do
      @article_collection.should belong_to(:created_by).of_type(User)
    end

    it "should belong_to a user with updated_by" do
      @article_collection.should belong_to(:updated_by).of_type(User)
    end

    it "should have_and_belong_to_many editors" do
      @article_collection.should have_and_belong_to_many(:editors).of_type(User)
    end

    it "should embed many articles" do
      @article_collection.should embed_many :articles
    end
    
  end

  # -- Validations -----
  describe "validations" do

    it "should be valid" do
      @article_collection.should be_valid
    end

    it "should not be valid without a site" do
      @article_collection.site_id = nil
      @article_collection.should_not be_valid
    end

    it "should not be valid without a name" do
      @article_collection.name = nil 
      @article_collection.should_not be_valid
    end

    it "should not be valid without a created_by" do
      @article_collection.created_by_id = nil
      @article_collection.should_not be_valid
    end
    
    it "should not be valid without a updated_by" do
      @article_collection.updated_by_id = nil
      @article_collection.should_not be_valid
    end
  end

end
