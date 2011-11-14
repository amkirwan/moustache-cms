require 'spec_helper'

describe Admin::CurrentSiteController do
  let(:current_site) { mock_model(Site, :id => "1", :name => "foobar").as_null_object }
  let(:current_admin_user) { logged_in(:role? => "admin", :site_id => current_site.id) }

  before(:each) do
    current_site.stub(:users).and_return([current_admin_user])
    cas_faker(current_admin_user.puid)
    stub_c_site_c_user(current_site, current_admin_user)
  end


  describe "GET edit" do
    let(:params) {{ "id" => current_site.to_param }}

    before(:each) do
      Site.stub(:find).and_return(current_site)
    end
    
    def do_get
      get :edit, params
    end

    it "should receive Site#find and return the current_site" do
      Site.should_receive(:find).with(params["id"]).and_return(current_site)
      do_get
    end

    it "should assign @current_site for the view" do
      do_get
      assigns(:current_site).should == current_site
    end

    it "should render the edit template" do
      do_get
      response.should render_template("admin/current_site/edit")
    end
  end

  describe "PUTS update" do
    let(:params) {{ "id" => current_site.to_param, "site" => {"name" => "foobar", "subdomain" => "foobar"} }}

    before(:each) do
      Site.stub(:find).and_return(current_site)
      current_site.stub(:update_attributes).and_return(true)
    end

    def do_puts(puts_params=params)
      put :update, puts_params
    end

    it "should receive Site#find and return the current_site" do
      Site.should_receive(:find).with("1").and_return(current_site)
      do_puts
    end

    it "should assign the current_site for the view" do
      do_puts
      assigns(:current_site).should == current_site
    end

    context "with valid params" do
      it "should receive update_attributes with params and return true" do
        current_site.should_receive(:update_attributes).with(params["site"])
        do_puts
      end

      it "should assign the flash message" do
        do_puts
        flash[:notice].should == "Successfully updated the site #{current_site.name}"
      end
      

      it "should redirect to the edit page" do
        do_puts
        response.should redirect_to([:edit, :admin, current_site])
      end
    end

    context "with invalid params" do
      before(:each) do
        current_site.stub(:update_attributes).and_return(false)
        current_site.stub(:errors => { :current_site => "current_site errors" })
      end

      it "should render the edit layout" do
        do_puts
        response.should render_template(:edit)
      end
    end
  end


  describe "DELETE destroy" do
    let(:params) {{ "id" => current_site.to_param }}

    before(:each) do
      Site.stub(:find).and_return(current_site)
    end

    def do_delete
      delete :destroy, params
    end

    it "should receive Site#find and return the current_site" do
      Site.should_receive(:find).with("1").and_return(current_site)
      do_delete
    end


    it "should assign the current site" do
      do_delete
      assigns(:current_site).should == current_site
    end

    it "should destroy the current_site" do
      current_site.should_receive(:destroy).and_return(true)
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
