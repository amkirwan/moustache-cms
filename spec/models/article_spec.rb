require 'spec_helper'


describe Article do

  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user, :site => site) }

  before(:each) do
   @article_collection = FactoryGirl.create(:article_collection, :articles => [], :site => site, :created_by => user, :updated_by => user)
   @article = FactoryGirl.create(:article, :site => site, :created_by_id => user.id, :updated_by_id => user.id, :article_collection => @article_collection)
  end

  # -- Associations ----
  describe "article associations" do

    it "should belong to a site" do
      @article.should belong_to(:site)
    end

    it "should embed_many meta_tags" do 
      @article.should embed_many :meta_tags
    end 

    it "should belong to article_collection" do
      @article.should belong_to(:article_collection)
    end  

    it "should belong to created_by of" do
      @article.should belong_to(:created_by).of_type(User)
    end

    it "should belong to updated_by of" do
      @article.should belong_to(:updated_by).of_type(User)
    end

    it "should belong to a layout" do
      @article.should belong_to(:layout)
    end

    it "should has_and_belong_to_many authors" do
      @article.should have_and_belong_to_many(:authors)
    end
    
  end

  # -- Validations ------
  describe "Validations" do
    it "should be valid" do
      @article.should be_valid
    end

    it "should not be valid without a site_id" do
      @article.site_id = nil
      @article.should_not be_valid
    end
        
    it "should not be valid without a title" do
      @article.title = nil 
      @article.should_not be_valid
    end

    it "should not be valid without a permalink" do
      @article.stub(:permalink_set).and_return(nil)
      @article.permalink = nil
      @article.should_not be_valid
    end

    it "should not be valid without a unique permalink" do
      FactoryGirl.build(:article, 
                    :site => site,
                    :title => @article.title,
                    :slug => @article.slug,
                    :permalink => @article.permalink,
                    :article_collection => @article_collection).should_not be_valid
    end

    it "should raise an error when the " do
      lambda do
        FactoryGirl.create(:article, :site => site, :permalink => @article.permalink)  
      end.should raise_error(Mongoid::Errors::Validations)
    end

    it "should not be valid without a slug" do
      @article.stub(:slug_set).and_return(nil)
      @article.slug = nil
      @article.should_not be_valid
    end

    it "should not be valid without a article_collection_id" do
      @article.article_collection_id = nil
      @article.should_not be_valid
    end

    it "should not be valid without a creator_id" do
      @article.created_by_id = nil
      @article.should_not be_valid
    end

    it "should not be valid without a updator_id" do
      @article.updated_by_id = nil
      @article.should_not be_valid
    end

    it "should not be valid without a filter_name" do
      @article.filter_name = nil
      @article.should_not be_valid
    end

  end

  # -- Before Validation Callback -------------------------------------------  
  describe "before_validation callback" do
    describe "#format_title" do
      it "should remove any leading or trainling white space from the title" do
        @article.title = " Hello, World!  \n"
        @article.save
        @article.title.should == "Hello, World!"
      end
    end
    
    describe "#slug_set" do
      it "should set the slug to the article title when the slug is blank" do
        @article.slug = nil
        @article.save
        @article.slug.should == @article.title.gsub(/[\s_]/, '-')
       end
      
      it "should remove any leading or trailing white space from the slug" do
        @article.slug = " Hello, World!  \n"
        @article.save
        @article.slug.should == "hello-world"
      end 
    end  

    describe "#permalink_set" do
      before(:each) do
        time = DateTime.now
        @year = time.year.to_s
        @month = time.month.to_s
        @day = time.day.to_s
        @collection_name = @article.article_collection.name.gsub(/[\s_]/, '-')
      end

      it "should not the prefix path to the permalink" do
        @article.permalink = nil
        @article.save
        @article.permalink.should == "/#{@year}/#{@month}/#{@day}/#{@article.slug}"
      end

      it "should add the prefix path to the permalink" do
        @article_collection.permalink_prefix = true
        @article.permalink = nil
        @article.save
        @article.permalink.should == "/#{@collection_name}/#{@year}/#{@month}/#{@day}/#{@article.slug}"
      end
    end
  end

  # -- Class Methods ----
  describe "Class Methods" do
    describe "article_by_permalink" do
      it "should return the article with the given permalink" do
        Article.article_by_permalink(@article.permalink).should == @article
      end
    end
  end

  # -- Instance Methods -----
  describe "Instance Methods" do

    describe "#datetime" do
      it "returns a dateime in iso8601 format for a associated date associated with the artcile" do
        @article.date = "2012-01-06 15:41:01"
        @article.datetime.should =~ /^(2012-01-06T15:41:01)(-|\+)(.*)/
      end
      
      it "should return an empty string if the dateime is nil" do
        @article.datetime.should == ''
      end
    end

    describe "#date_at_with_time" do
      it "returns an assigned date with the time for the article" do
        @article.date = "2012-01-06 15:41:01"
        @article.date_at_with_time.should == "January 06, 2012 at 3pm"
      end
    end

    describe "#date_at" do
      it "returns an assigned date for the article" do
        @article.date = "2012-01-06 15:41:01"
        @article.date_at.should == "January 06, 2012"  
      end  
    end
    
    describe "#dat_at_time_only" do
      it "returns an assigned date time for the article" do
        @article.date = "2012-01-06 15:41:01"
        @article.date == "3pm"    
      end
    end
  end

end
