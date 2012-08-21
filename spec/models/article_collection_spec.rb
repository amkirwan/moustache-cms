require 'spec_helper'

describe "ArticleCollection" do
  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    @article_collection = FactoryGirl.create(:article_collection, :site => site, :created_by => user, :updated_by => user)           
    @article_collection.articles << FactoryGirl.build(:article)
    @article_collection.articles << FactoryGirl.build(:article)
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

    it "should belong_to a layout with layout_id" do
      @article_collection.should belong_to(:layout).of_type(Layout)
    end

    it "should have_many articles_id" do
      @article_collection.should have_many(:articles)
    end

    it "should have_and_belong_to_many editors" do
      @article_collection.should have_and_belong_to_many(:editors).of_type(User)
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

    it "should set the permalink_prefix to false for a new article collection" do
      @article_collection.permalink_prefix.should == false  
    end

    it "should not set the permalink_prefix to false for a article collection saved to the database where it is set to true" do
      @article_collection.permalink_prefix = true
      @article_collection.save
      ArticleCollection.find(@article_collection.id).permalink_prefix.should == true
    end
  end

  # -- Class Methods ---
  describe "Class Methods" do
    describe "#articles_by_collection_name" do
      it "should return all the articles from a collection" do
        ArticleCollection.articles_by_collection_name_desc(@article_collection.name).to_a.should == @article_collection.articles  
      end
    end   

    describe "#articles_by_collection_name_desc" do
      it "should return all the articles from the collection sorted in descending order" do
        ArticleCollection.articles_by_collection_name_desc(@article_collection.name).to_a.should == @article_collection.articles.desc(:created_at).to_a
      end
      
    end
  end

end
