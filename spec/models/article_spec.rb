require 'spec_helper'


describe Article do

  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }

  before(:each) do
    @article = Factory.build(:article, :creator_id => user.id, :updator_id => user.id)
    @article_collection =Factory(:article_collection, :site => site, :created_by => user, :updated_by => user, :articles => [@article])
  end

  # -- Associations ----
  describe "article associations" do
     it "should be embeeded within a article_collection" do
       @article.should be_embedded_in(:article_collection)
     end  

     it "shuld embed one current state" do
       @article.should embed_one(:current_state)
     end

    it "should embed one current state" do
      @article.should embed_one :current_state
    end

    it "should embed_many meta_tags" do 
      @article.should embed_many :meta_tags
    end 
  end

  # -- Validations ------
  describe "Validations" do
    it "should be valid" do
      @article.should be_valid
    end
        
    it "should not be valid without a title" do
      @article.title = nil 
      @article.should_not be_valid
    end

    it "should not be valid without a unique title" do
      Factory.build(:article, 
                    :title => @article.title,
                    :article_collection => @article_collection).should_not be_valid
    end

    it "should not be valid without a permalink" do
      @article.stub(:permalink_set).and_return(nil)
      @article.permalink = nil
      @article.should_not be_valid
    end

    it "should not be valid without a unique permalink" do
      Factory.build(:article, 
                    :title => @article.title,
                    :slug => @article.slug,
                    :permalink => @article.permalink,
                    :article_collection => @article_collection).should_not be_valid
    end

    it "should not be valid without a slug" do
      @article.stub(:slug_set).and_return(nil)
      @article.slug = nil
      @article.should_not be_valid
    end

    it "should not be valid without a creator_id" do
      @article.creator_id = nil
      @article.should_not be_valid
    end

    it "should not be valid without a updator_id" do
      @article.updator_id = nil
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
        @article.slug.should == "hello,-world!"
      end 
    end  

    describe "#permalink_set" do
      it "should set the permalink" do
        time = DateTime.now
        year = time.year.to_s
        month = time.month.to_s
        day = time.day.to_s

        @article.permalink = nil
        @article.save
        collection_name = @article.article_collection.name.gsub(/[\s_]/, '-')
        @article.permalink.should == "/#{collection_name}/#{year}/#{month}/#{day}/#{@article.slug}"
      end
    end
  end

end
