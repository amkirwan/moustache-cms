require "spec_helper"

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::ArticleTags do
  include_context "mustache page setup"

  before(:each) do
    main_content = <<CONTENT
{{#articles_for_blog}}
  <h1>{{title}}</h1>
  <h2>{{subheading}}</h2>
{{/articles_for_blog}}
CONTENT
    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "main_content", 
                                      :content => main_content,
                                      :filter_name => "markdown") 
    @page.save

    @article_collection = FactoryGirl.build(:article_collection, :site => site, :name => 'blog')
    @article = FactoryGirl.build(:article, :site => site, :title => 'foobar', :content => 'Hello, World!', :article_collection => @article_collection)
    @article_collection.articles << @article
    @article_collection

    @controller.params = { :page => '1' }
    @cmsp.instance_variable_set(:@controller, @controller)
    @cmsp.instance_variable_set("@page", @page)
    @cmsp.instance_variable_set("@article", @article)
  end

  describe "articles should respond to the following tags" do
    specify { @cmsp.respond_to?(:articles_for).should be_true }
    specify { @cmsp.respond_to?(:articles_list_for).should be_true }
    specify { @cmsp.respond_to?(:article).should be_true }
    specify { @cmsp.respond_to?(:paginate_articles).should be_true }
    specify { @cmsp.respond_to?(:link_to_next_page).should be_true }
    specify { @cmsp.respond_to?(:link_to_previous_page).should be_true }
    specify { @cmsp.respond_to?(:page_entries_info).should be_true }
  end


  describe "it should create methods from ghost method calls" do
    it "should define a method for the call to articles_list_for_blog_(name)" do
      @cmsp.articles_list_for_blog
      @cmsp.class.attribute_method_generated?(:articles_list_for_blog).should be_true   
    end  

    it "should define a method for the call to articles__for_(name)" do
      @cmsp.articles_for_blog  
      @cmsp.class.attribute_method_generated?(:articles_for_blog).should be_true   
    end
  end

  describe "it should render the articles" do
    it "should return a list of the articles for articles_for_(name)" do
      @cmsp.articles_for_blog.should == [@article]  
    end

    it "should return the list of the articles for articles_list_for_(name)" do 
      @cmsp.instance_variable_set("@article", nil)
      @cmsp.articles_list_for_blog.should == [@article]  
    end
  end

  describe "it should render the article" do
    it "should return nil if the article instance variable @article is not nil" do
      @cmsp.articles_list_for_blog.should be_nil
    end

    it "should return the article" do
      @cmsp.article.should == @article
    end
  end

end
