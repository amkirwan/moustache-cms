require 'spec_helper'

describe Admin::CurrentSiteController do

  before(:each) do
    login_admin
    @current_site = @site
  end

  require 'spec_helper'

  describe "GET index" do
    def do_get
      get :index
    end

    let(:sites) { [mock_model(Site), mock_model(Site)] }  

    before(:each) do
      Site.stub(:accessible_by).and_return(sites)
    end

    it "should assign all the sites" do
      do_get
      assigns(:current_sites).should == sites
    end

    it "should assign the sites with current sites" do
      do_get
      assigns(:sites).should == sites
    end
  end
  
  describe "GET new" do
    def do_get
      get :new
    end

    before(:each) do
      @new_site = mock_model(Site).as_new_record
      Site.stub(:new).and_return(@new_site)
    end

    it "should receive new and return" do
      Site.should_receive(:new).and_return(@new_site)
      do_get  
    end

    it "should assign the @new_site for the view" do
      do_get
      assigns(:current_site).should == @new_site  
    end

    it "should assign the @site for the view" do
      do_get
      assigns(:site).should == @new_site  
    end

    it "should render the new template" do
      do_get
      response.should render_template("admin/current_site/new")
    end
  end

  describe "GET edit" do
    let(:params) {{ "id" => @current_site.to_param }}

    before(:each) do
      Site.stub(:find).and_return(@current_site)
    end
    
    def do_get
      get :edit, params
    end

    it "should receive Site#find and return the current_site" do
      Site.should_receive(:find).with(params["id"]).and_return(@current_site)
      do_get
    end

    it "should assign @current_site for the view" do
      do_get
      assigns(:current_site).should == @current_site
    end

    it "should render the edit template" do
      do_get
      response.should render_template("admin/current_site/edit")
    end
  end

  describe "POST create" do
    let(:params) {{ "site"=> {"name" => "blog", "subdomain" => "blog", "domain" => "org"} }}

    def do_post(post_params=params)
      post :create, post_params
    end

    before(:each) do
      @site.as_new_record
      Site.stub(:new).and_return(@site) 
    end

    it "should create a new site from the params" do
      Site.should_receive(:new).with(params["site"]).and_return(@site)
      do_post
    end

    it "should assign the @site for the view" do
      do_post
      assigns(:site).should == @site
    end

    context "with valid params" do
      before(:each) do
        @site.stub(:save).and_return(true)
      end

      it "should assign the flash message" do
        do_post
        flash[:notice].should_not be_empty
      end

      it "should redirect to the sites page" do
        do_post
        response.should redirect_to [:admin, :sites]
      end
    end

    context "with invalid params" do
      before(:each) do
        @site.stub(:save).and_return(false)
        @site.stub(:errors => {:anything => "site errors"})
      end

      it "should render the new template" do
        do_post
        response.should render_template('admin/current_site/new')
      end
    end
  end

  describe "PUTS update" do
    let(:params) {{ "id" => @current_site.to_param, "site" => {"name" => "foobar", "subdomain" => "foobar"} }}

    before(:each) do
      Site.stub(:find).and_return(@current_site)
      @current_site.stub(:update_attributes).and_return(true)
    end

    def do_puts(puts_params=params)
      put :update, puts_params
    end

    it "should receive Site#find and return the current_site" do
      Site.should_receive(:find).with(@current_site.id.to_s).and_return(@current_site)
      do_puts
    end

    it "should assign the @current_site for the view" do
      do_puts
      assigns(:current_site).should == @current_site
    end

    context "with valid params" do
      it "should receive update_attributes with params and return true" do
        @current_site.should_receive(:update_attributes).with(params["site"])
        do_puts
      end

      it "should assign the flash message" do
        do_puts
        flash[:notice].should == "Successfully updated the site #{@current_site.name}"
      end
      

      it "should redirect to the edit page" do
        do_puts
        response.should redirect_to([:edit, :admin, @current_site])
      end
    end

    context "with invalid params" do
      before(:each) do
        @current_site.stub(:update_attributes).and_return(false)
        @current_site.stub(:errors => { :current_site => "current_site errors" })
      end

      it "should render the edit layout" do
        do_puts
        response.should render_template(:edit)
      end
    end
  end


  describe "DELETE destroy" do
    let(:params) {{ "id" => @current_site.to_param }}

    before(:each) do
      Site.stub(:find).and_return(@current_site)
    end

    def do_delete
      delete :destroy, params
    end

    it "should receive Site#find and return the current_site" do
      Site.should_receive(:find).with(@current_site.id.to_s).and_return(@current_site)
      do_delete
    end


    it "should assign the current site" do
      do_delete
      assigns(:current_site).should == @current_site
    end

    it "should destroy the current_site" do
      @current_site.should_receive(:destroy).and_return(true)
      do_delete
    end

    it "should destroy the current session" do
      controller.should_receive(:reset_session)
      do_delete
    end
      
    it "should redirecto to the index page of the cms" do
      do_delete
      response.should redirect_to("http://test.host/")
    end
  end

end
