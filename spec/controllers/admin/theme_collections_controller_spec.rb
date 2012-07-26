require 'spec_helper'

describe Admin::ThemeCollectionsController do

  before(:each) do
    login_admin
    @theme_collection = mock_model(ThemeCollection, :site_id => @site.id).as_null_object
  end

  describe "GET index" do
    def do_get
      get :index
    end

    before(:each) do
      @theme_collections = [@theme_collection]
      ThemeCollection.stub(:accessible_by).and_return(@theme_collections)
    end

    it "should receive accesible_by" do
      ThemeCollection.should_receive(:accessible_by).and_return(@theme_collections)
      do_get
    end

    it "should assign the theme_collections" do
      do_get
      assigns[:theme_collections].should == @theme_collections
    end

    it "should render the index template" do
      do_get
      response.should render_template 'admin/theme_collections/index'
    end
  end

  describe "GET show" do
    def do_get
      get :show, :id => @theme_collection.id
    end

    before(:each) do
      ThemeCollection.stub(:find).and_return(@theme_collection)
    end

    it "should receive find and return the theme collection" do
      ThemeCollection.should_receive(:find).with(@theme_collection.to_param).and_return(@theme_collection)
      do_get
    end

    it "shoud assign the theme_collection" do
      do_get
      assigns[:theme_collection].should == @theme_collection
    end

    it "should render the show template" do
      do_get
      response.should render_template 'admin/theme_collections/show'
    end
  end

  describe "GET new" do
    def do_get
      get :new
    end

    before(:each) do
      @theme_collection.as_new_record
      ThemeCollection.stub(:new).and_return(@theme_collection)
    end

    it "should receive new and return a new theme_collection" do
      ThemeCollection.should_receive(:new).and_return(@theme_collection)
      do_get
    end

    it "shoud assign the theme_collection" do
      do_get
      assigns[:theme_collection].should == @theme_collection
    end

    it "should render the new template" do
      do_get
      response.should render_template 'admin/theme_collections/new'
    end
  end

  describe "GET edt" do
    def do_get
      get :edit, :id => @theme_collection.to_param
    end

    before(:each) do
      ThemeCollection.stub(:find).and_return(@theme_collection)
    end

    it "should receive find and return the theme_collection" do
      ThemeCollection.should_receive(:find).with(@theme_collection.to_param).and_return(@theme_collection)
      do_get
    end

    it "shoud assign the theme_collection" do
      do_get
      assigns[:theme_collection].should == @theme_collection
    end

    it "should render the new template" do
      do_get
      response.should render_template 'admin/theme_collections/edit'
    end
  end

  describe "POST create" do
    let(:params) { { 'theme_collection' => { 'name' => 'foobar' } } }

    def do_post(post_params=params)
      post :create, post_params
    end

    before(:each) do
      @theme_collection.as_new_record
      ThemeCollection.stub(:new).and_return(@theme_collection)
    end

    it "should receive new and return a new theme_collection" do
      ThemeCollection.should_receive(:new).and_return(@theme_collection)
      do_post
    end

    it "shoud assign the theme_collection" do
      do_post
      assigns[:theme_collection].should == @theme_collection
    end

    it "should assign created_updated_by" do
      controller.should_receive(:created_updated_by_for).with(instance_of(ThemeCollection))
      do_post
    end

    context "with valid params" do
      before(:each) do
        @theme_collection.stub(:save).and_return(true)
      end

      it "should receive save and return true" do
        @theme_collection.should_receive(:save).and_return(true)
        do_post
      end

      it "should set a flash notice message" do
        do_post
        flash[:notice].should_not be_nil
      end

      it "should redirect to the index page" do
        do_post
        response.should redirect_to [:admin, :theme_collections]
      end
    end

    context "with invalid params" do
      before(:each) do
        @theme_collection.stub(:save).and_return(false)
        @theme_collection.stub(:errors => { :layout => "layout errors" })
      end

      it "should receive save and return false" do
        @theme_collection.should_receive(:save).and_return(false)
        do_post
      end

      it "should render the new template after failed save" do
        do_post
        response.should render_template 'admin/theme_collections/new'
      end
    end
  end

  describe "PUT update" do
    let(:params) { {'id' => @theme_collection.to_param, 'theme_collection' => { 'name' => 'foobar' }} }

    def do_put(put_params=params)
      put :update, put_params
    end

    before(:each) do
      ThemeCollection.stub(:find).and_return(@theme_collection)
      FileUtils.stub(:mv).and_return(true)
    end

    it "should receive find the theme_collection" do
      ThemeCollection.should_receive(:find).and_return(@theme_collection)
      do_put 
    end

    it "shoud assign the theme_collection" do
      do_put 
      assigns[:theme_collection].should == @theme_collection
    end

    it "should update the path to the collection" do
      controller.should_receive(:move_directory)
      do_put
    end

    it "should assign updated_by" do
      @theme_collection.should_receive(:updated_by=).with(@current_admin_user)
      do_put
    end

    context "with valid params" do
      before(:each) do
        @theme_collection.stub(:update_attributes).and_return(true)
      end

      it "should receive update_attributes and return true" do
        @theme_collection.should_receive(:update_attributes).with(params['theme_collection']).and_return(true)
        do_put
      end

      it "should set a flash notice message" do
        do_put
        flash[:notice].should_not be_nil
      end

      it "should redirect to the index page" do
        do_put
        response.should redirect_to [:admin, :theme_collections]
      end
    end

    context "with invalid params" do
      before(:each) do
        @theme_collection.stub(:update_attributes).and_return(false)
        @theme_collection.stub(:errors => { :layout => "layout errors" })
      end

      it "should receive update_attributes and return false" do
        @theme_collection.should_receive(:update_attributes).and_return(false)
        do_put
      end

      it "should render the edit template after failed save" do
        do_put
        response.should render_template 'admin/theme_collections/edit'
      end
    end
  end

  describe "DELETE destroy" do
    def do_delete
      delete :destroy, :id => @theme_collection.id
    end

    before(:each) do
      ThemeCollection.should_receive(:find).and_return(@theme_collection)
      @theme_collection.stub(:persisted?).and_return(false)
    end

    it "should destroy the theme_collection" do
      @theme_collection.should_receive(:destroy).and_return(true)
      do_delete
    end

    it "should set the flash notice message" do
      do_delete
      flash[:notice].should_not be_nil
    end

    it "should redirect to the theme collection index page" do
      do_delete
      response.should redirect_to [:admin, :theme_collections]
    end
  end

end
