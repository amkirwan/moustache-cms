require 'spec_helper'


describe Article do

  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
  let(:layout) { Factory(:layout, :site_id => site.id, :created_by => user, :updated_by => user) }

  before(:each) do
    @article = Factory.build(:article, :site => site, :created_by => user, :updated_by => user)
    Factory(:article_collection, :site => site, :created_by => user, :updated_by => user, articles => [@article])
  end

  # -- Associations ----
  descirbe "article associations" do
     it "should be embeeded within a article_collection" do
       @article.should be_embedded_in(:article_collection)
     end  
  end

  # -- Before Create Callback -------------------------------------------      
  describe "before_create callback" do
    describe "#permalink_set" do
      it "it should set the permalink in the format http://example.com/year/month/day/post-title" do
        time = DateTime.now
        year = time.year.to_s
        month = time.month.to_s
        day = time.day.to_s
        @leaf.permalink.should == "http://#{@leaf.site.full_subdomain}/#{year}/#{month}/#{day}/#{@leaf.slug}"
      end
    end
  end

  describe "#permalink" do  
    it "should return the permalink in the format http://example.com/year/month/day/post-title" do
      time = DateTime.now
      year = time.year.to_s
      month = time.month.to_s
      day = time.day.to_s
      @leaf.permalink.should == "http://#{@leaf.site.full_subdomain}/#{year}/#{month}/#{day}/#{@leaf.slug}"
    end
  end

end
