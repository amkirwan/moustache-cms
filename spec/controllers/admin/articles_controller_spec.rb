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
      @ac.stub_chain(:articles, :desc).and_return(articles)
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

    it "should render the template" do
      do_get
      response.should render_template('admin/articles/new')
    end
  end

  #GET edit
  describe "GET edit" do
    before(:each) do
      @ac.stub_chain(:articles, :find).and_return(@article)
    end

    def do_get
      get :edit, :article_collection_id => @ac.to_param, :id => @article.to_param
    end

    it "should assign the @article_collection" do
      do_get
      assigns(:article_collection).should == @ac
    end

    it "should assign the @article" do
      do_get
      assigns(:article).should == @article
    end

    it "should render the template" do
      do_get
      response.should render_template('admin/articles/edit')
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
      controller.should_receive(:created_updated_by_for).with(instance_of(Article))
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

  describe "PUT update" do
    let(:params) { { "article_collection_id" => @ac.to_param, "id" => @article.to_param, "article" => { "title" => "foobar"}} }

    before(:each) do
      @ac.stub_chain(:articles, :find).and_return(@article)
    end
    
    def do_put(put_params=params)
      put :update, put_params
    end

    it "should assign the article_collection" do
      do_put
      assigns[:article_collection].should == @ac
    end

    it "should assign the article" do
      do_put
      assigns[:article].should == @article
    end

    it "should update updated_by attribute" do
      @article.should_receive(:updated_by=).with(@admin_user)
      do_put
    end

    context "valid params" do
      before(:each) do
        @article.stub(:update_attributes).and_return(true)
      end

      it "should receive update_attributes" do
        @article.should_receive(:update_attributes).and_return(true)
        do_put
      end

      it "should assign a flash message" do
        do_put
        flash[:notice].should_not be_empty
      end

      it "should redirect_to the index page" do
        do_put
        response.should redirect_to [:admin, @ac, :articles]
      end
    end

    context "invalid params" do
      before(:each) do
        @article.stub(:update_attributes).and_return(false)
        @article.stub(:errors => { :anything => "ac errors" })
      end

      it "should receive update_attributes" do
        @article.should_receive(:update_attributes).and_return(false)
        do_put
      end

      it "should render the edit template" do
        do_put
        response.should render_template('admin/articles/edit')
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @ac.stub_chain(:articles, :find).and_return(@article)
    end

    def do_delete
      delete :destroy, :article_collection_id => @ac.to_param, :id => @article.to_param
    end

    it "should assign the article collection" do
      do_delete
      assigns(:article_collection).should == @ac
    end


    it "should assign the article" do
      do_delete
      assigns(:article).should == @article 
    end

    context "with valid params" do
      before(:each) do
        @article.stub(:destroy).and_return(true)
      end

      it "should receive destroy" do
        @article.should_receive(:destroy).and_return(true)
        do_delete
      end

      it "should assign the flash message" do
        do_delete
        flash[:notice].should_not be_empty
      end
      
      it "should redirect to the index path" do
        do_delete
        response.should redirect_to [:admin, @ac, :articles]
      end
    end
  end

end
