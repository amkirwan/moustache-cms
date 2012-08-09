require "spec_helper"

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::ArticleTags do
  let(:site) { FactoryGirl.create(:site)}
  let(:user) { FactoryGirl.create(:user, :site => site) }
  let(:layout) { FactoryGirl.create(:layout, :site => site, :created_by => user, :updated_by => user) }

  before(:each) do
    @controller = CmsSiteController.new
    @page = FactoryGirl.create(:page, :title => "foobar", :site => site, :created_by => user, :updated_by => user)

    content = "{{#articles_for_foobar}}
                  <h1>{{title}}</h1>
                  <h2>{{subheading}}</h2>
              {{/articles_for_foobar}}" 
    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "content", 
                                      :content => content,
                                      :filter_name => "markdown") 

    @article_collection = FactoryGirl.create(:article_collection, :site => site, :name => 'blog')
    @article = FactoryGirl.create(:article, :site => site, :title => 'foobar', :content => 'Hello, World!')
    @article_collection.articles << @article

    @request = mock_model("Request", :host => "test.com", :protocol => 'http')

    @controller.instance_variable_set(:@page, @page)
    @controller.instance_variable_set(:@article, @article)
    @controller.instance_variable_set(:@request, @request)
    @controller.instance_variable_set(:@current_site, site)
    @cmsp = MoustacheCms::Mustache::CmsPage.new(@controller)
  end

  specify { @cmsp.respond_to?(:articles_for).should be_true }

  it "should define methods for article attributes that do not end with _id" do
    @cmsp.article_title.should == @article.title
    @cmsp.article_subheading.should == @article.subheading
  end

  it "should not define methods that end with _id" do
    lambda { @cmsp.article_site_id }.should raise_error(NoMethodError)
  end

  it "should respond with the articles in the collection" do
    @cmsp.articles_for('blog').should == [{ "title" => @article.title, "subheading" => @article.subheading}]
  end

end
