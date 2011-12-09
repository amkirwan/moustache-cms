require 'spec_helper'


describe Admin::AuthorsController do 

  before(:each) do
    login_admin
    @author = mock_model(Author, :site_id => @site.id).as_null_object
  end


  describe "GET index" do
    let(:authors) { [@author] }
    
    before(:each) do
      Author.stub(:accessible_by).and_return(authors)
    end
    
    def do_get
      get :index      
    end
    
    it "should receive Author#accessible_by and return asset_collection" do
      Author.should_receive(:accessible_by).and_return(authors)
      do_get
    end
    
    it "should assign authors" do
      do_get
      assigns(:authors).should == authors
    end
    
    it "should render in the index template" do
      do_get
      response.should render_template("admin/authors/index")
    end
  end

  describe "GET new" do
    
    before(:each) do
      @author.as_new_record
      Author.stub(:new).and_return(@author)
    end

    def do_get
      get :new
    end

    it "should receive new and return a new author" do
      Author.should_receive(:new).and_return(@author)
      do_get
    end

    it "should assign @author" do
      do_get
      assigns(:author).should == @author
    end

    it "should render the template new" do
      do_get
      response.should render_template('admin/authors/new')
    end
  end


  describe "GET edit" do
    let(:params) { { "id" => @author.to_param } }

    before(:each) do
      Author.stub(:find).and_return(@author)
    end

    def do_get
      get :edit, params
    end

    it "should find the author" do
      Author.should_receive(:find).with(params["id"]).and_return(@author)
      do_get
    end

    it "should assign the @author" do
      do_get
      assigns[:author].should == @author
    end

    it "should render the edit template" do
      do_get
      response.should render_template('admin/authors/edit')
    end
  end

  describe "POST create" do

    let(:params) { { "author" => {"firstname" => "Anthony", "lastname" => "Kirwan", "asset_cache" => "1/rails.png" }} }

    before(:each) do
      @author.as_new_record
      Author.stub(:new).and_return(@author)
    end

    def do_post(post_params=params)
      post :create, post_params
    end
    
    it "should create a new author from the params" do
      Author.should_receive(:new).with(params["author"]).and_return(@author)
      do_post
    end

    it "should assign @author for the view" do
      do_post
      assigns(:author).should == @author
    end

    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(@author)
      do_post
    end

    it "should assign the current_site" do
      @author.should_receive(:site=)
      do_post
    end

    context "with valid params" do
      before(:each) do
        @author.stub(:save).and_return(true)
      end

      it "should assign the flash message" do
        do_post
        flash[:notice].should_not be_empty
      end

      it "should redirect to the authors page" do
        do_post
        response.should redirect_to [:admin, :authors]
      end
    end

    context "with invalid params" do
      before(:each) do
        @author.stub(:save).and_return(false)
        @author.stub(:errors => { :anything => "layout errors" })
      end

      it "should render the new template" do
        do_post
        response.should render_template('admin/authors/new')
      end
    end
  end

end
