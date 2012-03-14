require 'spec_helper'

describe Admin::ThemeAssetsController do
  
  before(:each) do
    login_admin
    @theme_collection = mock_model(ThemeCollection, :site_id => @site.id).as_null_object
    @theme_asset = mock_model(ThemeAsset, :name => 'foobar', :_parent => @theme_collection, :filename_md5 => '12345', :asset => double('Asset').as_null_object).as_null_object
    @theme_assets = [@theme_asset]
    @theme_collection.stub(:theme_assets).and_return(@theme_assets)

    ThemeCollection.stub(:find).and_return(@theme_collection)
  end
  
  describe "GET index" do
    def do_get
      get :index, :theme_collection_id => @theme_collection.id
    end

    it "should assign the theme_collection" do
      do_get
      assigns[:theme_collection].should == @theme_collection
    end

    it "should redirect to: the theme_collection index page" do
      do_get
      response.should redirect_to([:admin, @theme_collection])
    end

  end
  
  describe "GET new" do
    before(:each) do
      @theme_assets.stub(:new).and_return(@theme_asset.as_new_record)
    end
    
    def do_get
      get :new, :theme_collection_id => @theme_collection.id
    end
    
    it "should receive ThemeAsset#new and return the new theme_asset" do
      @theme_assets.should_receive(:new).and_return(@theme_asset)
      do_get
    end
    
    it "should assign the new theme_asset to an ivar" do
      do_get
      assigns(:theme_asset).should == @theme_asset
    end
    
    it "should render the view template" do
      do_get
      response.should render_template("admin/theme_assets/new")
    end  
  end
  
  describe "POST create" do
    let(:params) { { "name" => "foobar", "asset_cache" => "1/rails.png", "asset" => AssetFixtureHelper.open("rails.png") } }
    
    before(:each) do
      @theme_assets.stub(:new).and_return(@theme_asset.as_new_record)
    end
    
    def do_post(post_params=params)
      post :create, :theme_collection_id => @theme_collection.id, "theme_asset" => post_params
    end
    
    it "should receive ThemeAsset#new and return the new theme_asset from the params" do
      @theme_assets.should_receive(:new).and_return(@theme_asset)
      do_post
    end
    
    it "should assign @theme_asset" do
      do_post
      assigns(:theme_asset).should == @theme_asset
    end
    
    context "with valid params" do
      before(:each) do
        @theme_asset.stub(:save).and_return(true)
      end
      
      it "should receive and save the theme_asset" do
        @theme_asset.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should assign to the flash message" do
        do_post
        flash[:notice].should == "Successfully created the theme asset #{@theme_asset.name}"
      end
    end
    
    context "using asset_cache when asset is nil on redisplay, ie validation fails" do
      it "should set the asset to the asset_cache when the asset_cache is not empty and the asset is nil" do   
        controller.should_receive(:try_theme_asset_cache)
        do_post({ "asset_cache" => "1/rails.png" })
      end
    end
    
    context "with invalid params" do
      before(:each) do
        @theme_asset.stub(:save).and_return(false)
        @theme_asset.stub(:errors => { :theme_asest => "theme_asset errors" })
      end
      
      it "should receive save and return false" do
        @theme_asset.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/theme_assets/new")
      end
    end    
  end  

  describe "GET edit" do
    before(:each) do
      @theme_assets.stub(:find).and_return(@theme_asset)
    end                                                      
    
    def do_get
      get :edit, :theme_collection_id => @theme_collection.id, "id" => @theme_asset.to_param
    end
    
    it "should receive ThemeAsset#find and return the theme_asset" do
      @theme_assets.should_receive(:find).and_return(@theme_asset)
      do_get
    end
    
    it "should assign the theme_asset for the view" do
      do_get
      assigns(:theme_asset).should == @theme_asset
    end                                          
    
    it "should render the view" do
      do_get
      response.should render_template("admin/theme_assets/edit")
    end
  end
  
  
  describe "PUT update" do    
    before(:each) do
      @theme_assets.stub(:find).and_return(@theme_asset)
    end                                            
    
    let(:params) { { "id" => @theme_asset.to_param, "theme_asset_file_content" => "foobar", "theme_asset" => { "name" => "foobar" }, "theme_collection_id" => @theme_collection.to_param} }

    def do_put(put_params=params)
      put :update, put_params
    end
    
    it "should receive ThemeAsset#find" do
      @theme_assets.should_receive(:find).and_return(@theme_asset)
      do_put
    end                                                        
    
    it "should assign the updated_by attribute" do
      @theme_asset.should_receive(:updator_id=).with(@admin_user.id)
      do_put
    end
    
    it "should assign the theme_asset for the view" do
      do_put
      assigns(:theme_asset).should == @theme_asset
    end     
    
    describe "with valid params" do
      before(:each) do
        @theme_asset.stub(:update_attributes).and_return(true)
        @theme_asset.stub(:update_file_content).and_return(true)
      end

      it "should receive update_attributes and return true" do
        @theme_asset.should_receive(:update_attributes).with(params["theme_asset"]).and_return(true)
        do_put
      end             
      
      it "should receive @theme_asset.update_file_content" do
        @theme_asset.should_receive(:update_file_content).with(params["theme_asset_file_content"]).and_return(true)
        do_put
      end
      
      it "should assign the flash message" do
        do_put                               
        flash[:notice].should == "Successfully updated the theme asset #{@theme_asset.name}"
      end           
      
      it "should redirect to the index action" do
        do_put
        response.should redirect_to([:admin, @theme_collection, :theme_assets])
      end 
    end 
    
    context "using asset_cache when asset is nil on redisplay, ie validation fails" do
      it "should set the asset to the asset_cache when the asset_cache is not empty and the asset is nil" do   
        do_put("id" => @theme_asset.to_param, "theme_asset" => { "asset_cache" => "1/rails.png"}, "theme_collection_id" => @theme_collection.to_param)
      end
    end                                 
    
    describe "with invalid params" do                      
      before(:each) do
        @theme_asset.stub(:update_attributes).and_return(false)
        @theme_asset.stub(:errors => { :theme_asest => "theme_asset errors" })
      end
      
      it "should receive update_attributes and return false" do
        @theme_asset.should_receive(:update_attributes).and_return(false)
        do_put
      end             
      
      it "should render the templete for edit" do
        do_put
        response.should render_template("admin/theme_assets/edit")
      end
    end   
  end  
  
  describe "DELETE destroy" do
    before(:each) do
      @theme_assets.stub(:find).and_return(@theme_asset)
      @theme_asset.stub(:persisted?).and_return(false)
    end         
    
    def do_destroy
      delete :destroy, "theme_collection_id" => @theme_collection.id, "id" => @theme_asset.id
    end                                   
    
    it "should receive ThemeAsset#find and return theme_asset" do
      @theme_assets.should_receive(:find).with(@theme_asset.id.to_s).and_return(@theme_asset)
      do_destroy
    end                              
    
    it "should assign the theme_asset" do        
      do_destroy
      assigns(:theme_asset).should == @theme_asset
    end         

    context "when destroying theme_asset is successful" do
      it "should receive destroy and return true" do
        @theme_asset.should_receive(:destroy).and_return(true)
        do_destroy
      end                                                  
      
      it "should set the flash message" do
        do_destroy
        flash[:notice].should == "Successfully deleted the theme asset #{@theme_asset.name}"
      end
      
      it "should redirect to the theme_asset index page" do
        do_destroy
        response.should redirect_to([:admin, @theme_collection, :theme_assets])
      end
    end
  end
end 







