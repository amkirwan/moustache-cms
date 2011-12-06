require 'spec_helper'

describe Admin::ArticleCollectionsController do

  before(:each) do
    login_admin
    @article_collection = mock_model(ArticleCollection, :site_id => @site.id).as_null_object
  end
  
  describe "GET index" do    
    let(:article_collections) { [@article_collection] }
      
    before(:each) do
      ArticleCollection.stub(:accessible_by).and_return(article_collections)
    end
    
    def do_get
      get :index
    end
      
    it "should receive accessible_by" do
      ArticleCollection.should_receive(:accessible_by).and_return(article_collections)
      do_get
    end
    
    it "should assign the found layouts" do
      do_get
      assigns(:article_collections).should == article_collections
    end
    
    it "should render the index template" do
      do_get
      response.should render_template("admin/article_collections/index")
    end
  end

  describe "GET new" do

    before(:each) do
      ArticleCollection.stub(:new).and_return(@article_collection.as_new_record)
    end

    def do_get
      get :new
    end

    it "should create a new article_collection" do
      ArticleCollection.should_receive(:new).and_return(@article_collection)
      do_get
    end

    it "should assign the @article_collection" do
      do_get
      assigns(:article_collection).should == @article_collection
    end

    it "should render the new view" do
      do_get
      response.should render_template("admin/article_collections/new")
    end
  end

  describe "GET show" do

    before(:each) do
      ArticleCollection.stub(:find).and_return(@article_collection)
    end

    def do_get
      get :show, "id" => @article_collection.to_param
    end

    it "should find the article collection" do
      ArticleCollection.should_receive(:find).and_return(@article_collection)
      do_get
    end

    it "should assign the @article_collection" do
      do_get
      assigns(:article_collection).should == @article_collection
    end

    it "should render the show layout" do
      do_get
      response.should render_template("admin/article_collections/show")
    end

  end

  describe "POST create" do

    let(:params) { {"article_collection" => {"name" => "foobar"}} }

    before(:each) do
        ArticleCollection.stub(:new).and_return(@article_collection.as_new_record)
    end

    def do_post(post_params=params)
      post :create, post_params 
    end

    it "ArticleCollection should receive new" do
      ArticleCollection.should_receive(:new).with(params["article_collection"]).and_return(@article_collection)
      do_post
    end

    it "should assign the @article_collection" do
      do_post
      assigns(:article_collection).should == @article_collection
    end

    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(@article_collection)
      do_post
    end

    it "should assig nthe current site to the @article_collection" do
      @article_collection.should_receive(:site=)
      do_post
    end


    context "valid params" do
      before(:each) do
        @article_collection.stub(:save).and_return(true)
      end

      it "should receive save and return true" do
        @article_collection.should_receive(:save).and_return(true)
        do_post
      end

      it "should render the new index template when saving successfully" do
        do_post
        response.should redirect_to("/admin/article_collections")
      end
    end

    context "invalid params" do
      before(:each) do
        @article_collection.stub(:save).and_return(false)
        @article_collection.stub(:errors => { :anything => "ac errors" })
      end

      it "should receive save and return false" do
        @article_collection.should_receive(:save).and_return(false)
        do_post
      end

      it "should render the new template when saving has validation errors" do
        do_post
        response.should render_template("admin/article_collections/new")
      end
    end

  end

end
