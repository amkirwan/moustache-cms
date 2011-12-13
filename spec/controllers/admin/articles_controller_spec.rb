require 'spec_helper'

describe Admin::ArticlesController do

  before(:each) do
    login_admin
    @article = mock_model(Article, :site_id => @site.id).as_null_object
    @ac = mock_model(ArticleCollection, :site_id => @site.id, :articles => [@article]).as_null_object
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

  #POST create
  describe "POST create" do
    let(:params) { { "article_collection_id" => @ac.to_param, "article" => { "title" => "blog title" }} }

    before(:each) do
      @ac.stub_chain(:articles, :new).and_return(@article.as_new_record)
    end

    def do_post(post_params=params)
      post :create, post_params
    end

    it "should assign the @article_collection" do
      do_post
      assigns(:article_collection).should == @ac
    end

    it "should assign the @article" do
      do_post
      assigns(:article).should == @article
    end

    it "should receive created_updated_by_for" do
      controller.should_receive(:created_updated_by_for).with(@article)
      do_post
    end

    it "should assign a site" do
      @article.should_receive(:site=)
      do_post
    end

    context "valid params" do
      before(:each) do
        @article.stub(:save).and_return(true)
      end

      it "should receive save and return true" do
        @article.should_receive(:save).and_return(true)
        do_post
      end

      it "should assign the flash message" do
        do_post
        flash[:notice].should_not be_empty
      end

      it "should render the articles index template when saving successfully" do
        do_post
        response.should redirect_to [:admin, @ac, :articles]
      end
    end

    context "invalid params" do
      before(:each) do
        @article.stub(:save).and_return(false)
        @article.stub(:errors => { :anything => "article errors" })
      end

      it "should receive save and return false" do
        @article.should_receive(:save).and_return(false)
        do_post
      end

      it "should render the new template" do
        do_post
        response.should render_template("admin/articles/new")
      end
    end

  end
end
