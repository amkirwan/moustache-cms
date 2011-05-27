require 'spec_helper'

describe Admin::SiteAssetsController do

  #for actions
  let(:site) { mock_model(Site, :id => "1") }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:site_asset) { mock_model("SiteAsset", :site_id => site.id).as_null_object }
  
  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)
  end

  # -- GET Index ----------------------------------------------- 
  describe "GET index" do
    def do_get     
      get :index
    end
    
    let(:site_assets) { [mock_model("SiteAsset"), mock_model("SiteAsset")] }
    
    before(:each) do
      SiteAsset.stub(:accessible_by).and_return(site_assets)
    end
    
    
    it "should receive accessible_by" do
      SiteAsset.should_receive(:accessible_by).and_return(site_assets)
      do_get
    end
    
    it "should assign the found site_assets" do
      do_get
      assigns(:site_assets).should == site_assets
    end
    
    it "should render the index template" do
      do_get
      response.should render_template("admin/site_assets/index")
    end
  end
  
  describe "GET new" do
    def do_get
      get :new
    end
    
    before(:each) do
      site_asset.as_new_record
      SiteAsset.stub(:new).and_return(site_asset)
    end
    
    it "should receive new and return a new site_asset" do
      SiteAsset.should_receive(:new).and_return(site_asset)
      do_get
    end
    
    it "should assign the new site_asset for the view" do
      do_get
      assigns(:site_asset).should == site_asset
    end
    
    it "should render the new template" do
      do_get
      response.should render_template("admin/site_assets/new")
    end
  end
  
  describe "POST create" do
    
    let(:params) { { "name" => "foobar", "source_cache" => "1/rails.png", "source" => AssetFixtureHelper.open("rails.png") } }
    
    before(:each) do
      site_asset.as_new_record
      SiteAsset.stub(:new).and_return(site_asset)
    end
    
    def do_post(post_params=params)
      post :create, "site_asset" => post_params
    end
    
    it "should create a new site_asset from the params" do
      SiteAsset.should_receive(:new).with(params).and_return(site_asset)
      do_post
    end
    
    it "should assign the @site_asset for the view" do
      do_post
      assigns(:site_asset).should == site_asset
    end
    
    it "should assign created_by and updated_by to the current user" do
      controller.should_receive(:created_updated_by_for).with(site_asset)
      do_post
    end
    
    it "should assign the @current_site to the site_asset" do
      site_asset.should_receive(:site=)
      do_post
    end
      
    context "with valid params" do
      it "should receive and save the site_asset" do
        site_asset.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should assign a flash message that the site_asset was saved" do
        do_post
        flash[:notice].should == "Successfully created the asset #{site_asset.name}"
      end
      
      it "should redirect to the admin/site_assets/index" do
        do_post
        response.should redirect_to(admin_site_assets_path)
      end
    end    
    
    context "using source_cache when source is nil on redisplay, ie validation fails" do
      it "should set the source to the source_cache when the source_cache is not empty and the source is nil" do   
        site_asset.stub_chain(:source, :retrieve_from_cache!)
        site_asset.stub_chain(:source, :store!)
        controller.should_receive(:set_from_cache).with("1/rails.png")
        do_post({ "source_cache" => "1/rails.png"})
      end
    end
    
    context "with invalid params" do
      before(:each) do
        site_asset.stub(:save).and_return(false)
      end
      
      it "should receive save and return false" do
        site_asset.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/site_assets/new")
      end
    end
  end
  
  describe "GET edit" do
    before(:each) do
      SiteAsset.stub(:find).and_return(site_asset)
    end
    
    def do_get
      get :edit, "id" => site_asset.to_param
    end
    
    it "should should receive SiteAsset#find and return the site_asset" do
      SiteAsset.should_receive(:find).and_return(site_asset)
      do_get
    end

    it "should assign @site_asset for the view" do
      do_get
      assigns(:site_asset).should == site_asset
    end

    it "should render the template admin/site_asset/edit" do
      do_get
      response.should render_template("admin/site_assets/edit")
    end    
  end

  describe "PUT update" do
    before(:each) do
      SiteAsset.stub(:find).and_return(site_asset)
    end
    
    let(:params) { { "id" => site_asset.to_param, "site_asset" => { "name" => "foobar", "source_cache" => "1/rails.png", "source" => AssetFixtureHelper.open("rails.png")}} }
    
    def do_put(put_params=params)
      post :update, put_params
    end
    
    it "should receive the SiteAsset#find and return the media file" do
      SiteAsset.should_receive(:find).with(site_asset.to_param).and_return(site_asset)
      do_put
    end
    
    it "should assign @site_asset for the view" do
      do_put
      assigns(:site_asset).should == site_asset
    end
    
    it "should update updated_by attribute" do
      site_asset.should_receive(:updated_by=).with(current_user)
      do_put
    end
    
    describe "with valid params" do
      it "should receive update_attributes and return true" do
        site_asset.should_receive(:update_attributes).with(params["site_asset"]).and_return(true)
        do_put
      end
      
      it "should assign the flash message with successful update" do
        do_put
        flash[:notice].should == "Successfully updated the asset #{site_asset.name}"
      end
      
      it "should redirect to the site_asset index page" do
        do_put
        response.should redirect_to(admin_site_assets_path)
      end
    end
    
    context "using source_cache when source is nil on redisplay, ie validation fails" do
      it "should set the source to the source_cache when the source_cache is not empty and the source is nil" do   
        site_asset.stub_chain(:source, :retrieve_from_cache!)
        site_asset.stub_chain(:source, :store!)
        controller.should_receive(:set_from_cache).with("1/rails.png")
        do_put("id" => site_asset.to_param, "site_asset" => { "source_cache" => "1/rails.png"})
      end
    end
    
    describe "without valid params" do
      before(:each) do
        site_asset.stub(:update_attributes).and_return(false)
      end
      
      it "should receive update_attributes and return false" do
        site_asset.should_receive(:update_attributes).and_return(false)
        do_put
      end
      
      it "should render the site_asset edit template on failed update" do
        do_put
        response.should render_template("admin/site_assets/edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      SiteAsset.stub(:find).and_return(site_asset)
    end
    
    def do_destroy
      delete :destroy, "id" => site_asset.to_param
    end
    
    it "should receive the SiteAsset#find and return the media file" do
      SiteAsset.should_receive(:find).with(site_asset.to_param).and_return(site_asset)
      do_destroy
    end
    
    it "should assign the flash message that the media file was successfully destroyed" do
      do_destroy
      flash[:notice].should == "Successfully deleted the asset #{site_asset.name}"
    end
    
    it "should redirect to admin/site_asset/index when the file is destroyed" do
      do_destroy
      response.should redirect_to(admin_site_assets_path)
    end
  end
end
