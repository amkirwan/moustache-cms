require 'spec_helper'

describe Admin::ArticlesController do

  before(:each) do
    login_admin
    @article = mock_model(Article, :site_id => @site.id).as_null_object
    @ac = mock_model(ArticleCollection, :site_id => @site.id, :articles => [@article])
    ArticleCollection.stub(:find).and_return(@ac)
  end

  #GET index
  describe "GET index" do
    let(:articles) { [@article] }

    before(:each) do
      @ac.stub_chain(:articles, :asc).and_return(articles)
      articles.stub(:page).and_return(articles)
    end

    def do_get
      get :index, :article_collection_id => @ac.to_param
    end

    it "should assign the @article_collection" do
      do_get
      assigns(:article_collection).should == @ac
    end

    it "should assign the @articles" do
      do_get
      assigns(:articles).should == articles
    end
    
    it "should render the view" do
      do_get
      response.should render_template('admin/articles/index')
    end
  end

  #GET new
  describe "GET new" do
    before(:each) do
      @article.as_new_record
      @ac.stub_chain(:articles, :new).and_return(@article)
    end

    def do_get
      get :new, :article_collection_id => @ac.to_param
    end

    it "should assign the @article_collection" do
      do_get
      assigns(:article_collection).should == @ac
    end

    it "should assign the @article" do
      do_get
      assigns(:article).should == @article
    end

  end

end
