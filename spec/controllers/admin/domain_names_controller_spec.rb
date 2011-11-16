require 'spec_helper'

describe Admin::DomainNamesController do
  let(:current_site) { mock_model(Site, :id => "1", :name => "foobar").as_null_object }
  let(:current_admin_user) { logged_in(:role? => "admin", :site_id => current_site.id) }

  before(:each) do
    current_site.stub(:users).and_return([current_admin_user])
    cas_faker(current_admin_user.username)
    stub_c_site_c_user(current_site, current_admin_user)
  end


  describe "GET new" do
    let(:params) {{ "site_id" => current_site.to_param }}

    before(:each) do
      Site.stub(:find).and_return(current_site)
    end
    
    def do_get
      get :new, params
    end

    it "should assign the current_site" do
      do_get
      assigns(:current_site).should == current_site
    end
    
    it "should render the new template" do
      do_get
      response.should render_template("admin/domain_names/new")
    end
  end

  describe "POST create" do
    let(:params) {{ "site_id" => current_site.to_param, "site" => { "domain_name" => "foobar" } }}
    let(:domain) { "test.com" }
    let(:domain_names) { [domain_names] }

    before(:each) do
      Site.stub(:find).and_return(current_site)
      current_site.stub_chain(:domain_names, :<<)
    end

    def do_post
      post :create, params
    end

    it "should assign the current_site" do
      do_post
      assigns(:current_site).should == current_site
    end

    context "with valid params" do

      it "should receive domain_names and add the domain name to the array" do
        current_site.should_receive(:domain_names)
        do_post
      end

      it "should save the current_site" do
        current_site.should_receive(:save)
        do_post
      end

      it "should redirect to the current_site" do
        do_post
        response.should redirect_to([:edit, :admin, current_site])
      end

      it "should set the flash message" do
        do_post
        flash[:notice].should == "Successfully created the domain name #{params["site"]["domain_name"]}"
      end
    end

    context "with invalid params" do
      before(:each) do
        current_site.stub(:save).and_return(false)
        current_site.stub(:errors => { :current_site => "current_site errors" })
      end

      it "should render the new template" do
        do_post
        response.should render_template(:new)
      end
    end

  end

  describe "DELETE destroy" do
    let(:params) {{ "site_id" => current_site.to_param, "id" => "0" }}
    let(:domain_name) { "test.com" }
    let(:domain_names) { [domain_name] }

    before(:each) do
      current_site.stub(:domain_names).and_return(domain_names)
      Site.stub(:find).and_return(current_site)
    end

    def do_delete
      delete :destroy, params
    end

    it "should assign the current_site" do
      do_delete
      assigns(:current_site).should == current_site
    end

    it "should assign the domain_name" do
      do_delete
      assigns(:domain_name).should == domain_name
    end
      
    context "with valid params" do
      it "should destroy the meta_tag" do
        current_site.should_receive(:domain_names).and_return(domain_names)
        domain_names.should_receive(:delete_at)
        do_delete
      end

      it "should receive save" do
        current_site.should_receive(:save)
        do_delete
      end

      it "should redirect to the current_site" do
        do_delete
        response.should redirect_to([:edit, :admin, current_site])
      end

      it "should set the the flash notice message" do
        do_delete
        flash[:notice].should == "Successfully deleted the domain name #{domain_name}"
      end
    end
  end

end
