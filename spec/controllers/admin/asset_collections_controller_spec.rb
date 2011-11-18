require 'spec_helper'

describe Admin::AssetCollectionsController do
  
  before(:each) do
    login_admin
    @asset_collection = mock_model(AssetCollection, :site_id => @site.id).as_null_object
  end


  describe "GET index" do
    let(:asset_collections) { [@asset_collection] }
    
    before(:each) do
      AssetCollection.stub(:accessible_by).and_return(asset_collections)
    end
    
    def do_get
      get :index      
    end
    
    it "should receive AssetCollection#accessible_by and return asset_collection" do
      AssetCollection.should_receive(:accessible_by).and_return(asset_collections)
      do_get
    end
    
    it "should assign asset_collections" do
      do_get
      assigns(:asset_collections).should == asset_collections
    end
    
    it "should render in the index template" do
      do_get
      response.should render_template("admin/asset_collections/index")
    end
  end
  
  describe "GET show" do
    before(:each) do
      AssetCollection.stub(:find).and_return(@asset_collection)
    end
    
    def do_get
      get :show, "id" => @asset_collection.to_param
    end
    
    it "should receive AssetCollection#find" do
      AssetCollection.should_receive(:find).and_return(@asset_collection)
      do_get
    end
    
    it "should assign asset_collection" do
      do_get
      assigns(:asset_collection).should == @asset_collection
    end
    
    it "should render the show template" do
      do_get
      response.should render_template("admin/asset_collections/show")
    end    
  end
  
  describe "GET new" do
    before(:each) do
      AssetCollection.stub(:new).and_return(@asset_collection.as_new_record.as_null_object)
    end
    
    def do_get
      get :new
    end

    it "should receive AssetCollection.new" do
      AssetCollection.should_receive(:new).and_return(@asset_collection)
      do_get
    end
    
    it "should assign @asset_collection" do
      do_get
      assigns(:asset_collection).should == @asset_collection
    end
    
    it "should render the new template" do
      do_get
      response.should render_template("admin/asset_collections/new")
    end    
  end
  
  describe "GET edit" do
    before(:each) do
      AssetCollection.stub(:find).with(@asset_collection.to_param).and_return(@asset_collection)
    end
    
    def do_get
      get :edit, "id" => @asset_collection.to_param
    end
    
    it "should receive AssetCollection.find" do
      AssetCollection.should_receive(:find).and_return(@asset_collection)
      do_get
    end
    
    it "should assign @asset_collection" do
      do_get
      assigns(:asset_collection).should == @asset_collection
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template("admin/asset_collections/edit")
    end
  end
  
  describe "POST create" do
    let(:params) {{ "asset_collection" => { "name" => "foobar" }}}
    
    before(:each) do
      @asset_collection.as_new_record
      AssetCollection.stub(:new).and_return(@asset_collection.as_null_object)
    end
    
    def do_post(post_params=params)
      post :create, post_params
    end
    
    it "should receive AssetCollection.new" do
      AssetCollection.should_receive(:new).and_return(@asset_collection)
      do_post
    end
    
    it "should assign @asset_collection" do
      do_post
      assigns(:asset_collection).should == @asset_collection
    end
    
    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(@asset_collection)
      do_post
    end
    
    it "should assign the current_site" do
      @asset_collection.should_receive(:site=).with(@site)
      do_post
    end
    
    context "with valid params" do
      it "should receive save and return true" do
        @asset_collection.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should assign the flash message" do
        do_post
        flash[:notice].should == "Successfully created the asset collection #{@asset_collection.name}"
      end
      
      it "should redirect to the index template" do
        do_post
        response.should redirect_to admin_asset_collections_path
      end
    end
    
    context "with invalid params" do
      before(:each) do
        @asset_collection.stub(:save).and_return(false)
        @asset_collection.stub(:errors => { :asset_collection => "asset_collection errors" })
      end
      
      it "should receive save and return false" do
        @asset_collection.should_receive(:save).and_return(false)
        do_post  
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/asset_collections/new")
      end
    end
  end
  
  describe "PUT update" do
    let(:params) { { "id" => @asset_collection.to_param, "asset_collection" => { "name" => "foobar" } } }
    
    before(:each) do
      AssetCollection.stub(:find).and_return(@asset_collection)
    end
    
    def do_put(put_params=params)
      put :update, put_params
    end
    
    it "should receive AssetCollection.find" do
      AssetCollection.should_receive(:find).and_return(@asset_collection)
      do_put
    end
    
    it "should assign @asset_collection" do
      do_put
      assigns(:asset_collection).should == @asset_collection
    end
    
    it "should update updated_by attribute" do
      @asset_collection.should_receive(:updated_by=).with(@admin_user)
      do_put
    end
    
    context "with valid params" do
      it "should receive update_attributes and update" do
        @asset_collection.should_receive(:update_attributes).with(params["asset_collection"]).and_return(true)
        do_put
      end
      
      it "should assign the flash message" do
        do_put
        flash[:notice].should == "Successfully updated the asset collection #{@asset_collection.name}"
      end
      
      it "should redirect to index template" do
        do_put
        response.should redirect_to admin_asset_collection_path(@asset_collection)
      end
    end
    
    context "with invalid params" do
      before(:each) do
        @asset_collection.should_receive(:update_attributes).and_return(false)
        @asset_collection.stub(:errors => { :asset_collection => "asset_collection errors" })
      end
      
      it "should render the edit template" do
        do_put
        response.should render_template("admin/asset_collections/edit")
      end
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      AssetCollection.stub(:find).and_return(@asset_collection)
      @asset_collection.stub(:persisted?).and_return(false)
    end
    
    def do_delete
      delete :destroy, "id" => @asset_collection.id
    end
    
    it "should receive AssetCollection.find" do
      AssetCollection.should_receive(:find).with(@asset_collection.id.to_s).and_return(@asset_collection)
      do_delete
    end
    
    it "should assign @asset_collection" do
      do_delete
      assigns(:asset_colletion).should @asset_collection
    end
    
    it "should receive destroy and return true" do
      @asset_collection.should_receive(:destroy).and_return(true)
      do_delete
    end
    
    it "should assign the flash message" do
      do_delete
      flash[:notice].should == "Successfully deleted the asset collection #{@asset_collection.name}"
    end
    
    it "should redirect to the index path" do
      do_delete
      response.should redirect_to admin_asset_collections_path
    end
  end
end
