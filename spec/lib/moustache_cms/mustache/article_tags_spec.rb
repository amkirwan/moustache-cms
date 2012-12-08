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
    feed_content = "<title>Qux</title>"

    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "main_content", 
                                      :content => main_content,
                                      :filter_name => "markdown") 
    @page.page_parts << FactoryGirl.build(:page_part,
                                          name: 'feed',
                                          content: feed_content,
                                          filter_name: 'html')

    @page.save

    @article_collection = FactoryGirl.build(:article_collection, :site => site, :name => 'blog')
    @article = FactoryGirl.build(:article, :site => site, :title => 'foobar', :content => 'Hello, World!', :article_collection => @article_collection)
    @article_collection.articles << @article
    @article_collection

    @controller.params = { :page => '1' }
    @cmsp.instance_variable_set(:@controller, @controller)
    @cmsp.instance_variable_set("@page", @page)
    @cmsp.instance_variable_set("@article", @article)
    @cmsp.instance_variable_set("@articles", [@article])
    @cmsp.instance_variable_set("@articles_published", [@article])
  end

  describe "articles should respond to the following tags" do
    specify { @cmsp.respond_to?(:articles_for).should be_true }
    specify { @cmsp.respond_to?(:article).should be_true }
    specify { @cmsp.respond_to?(:articles).should be_true }
    specify { @cmsp.respond_to?(:articles_published).should be_true }
    specify { @cmsp.respond_to?(:feed_for).should be_true }
    specify { @cmsp.respond_to?(:feed_updated).should be_true }
    specify { @cmsp.respond_to?(:form_for_comment).should be_true }
    specify { @cmsp.respond_to?(:comments).should be_true }
    specify { @cmsp.respond_to?(:error_messages).should be_true }
    specify { @cmsp.respond_to?(:generate_atom_feed).should be_true }
    specify { @cmsp.respond_to?(:paginate_articles).should be_true }
    specify { @cmsp.respond_to?(:link_to_next_page).should be_true }
    specify { @cmsp.respond_to?(:link_to_previous_page).should be_true }
    specify { @cmsp.respond_to?(:page_entries_info).should be_true }
  end


  describe "it should create methods from ghost method calls" do
    it "should define a method for the call to articles_for_(name)" do
      @cmsp.articles_for_blog  
      @cmsp.class.attribute_method_generated?(:articles_for_blog).should be_true   
    end

    it "should define a method for the call to feed_for_(name)" do
      @cmsp.feed_for_blog
      @cmsp.class.attribute_method_generated?(:feed_for_blog).should be_true   
    end
  end

  describe "#methods" do
    it "should return a list of the articles for articles_for_(name)" do
      @cmsp.articles_for_blog.should == [@article]  
    end
    
    it "should return the article" do
      @cmsp.article.should == @article
    end

    it "should retun all the articles" do
      @cmsp.articles.should == [@article]
    end

    it "should return feed updated date in xml format" do
      @cmsp.feed_updated.should == @article.updated_at.xmlschema
    end

    it "should return the feed" do
      @cmsp.feed_for_blog.should == "<title>Qux</title>"
    end
  end

end
