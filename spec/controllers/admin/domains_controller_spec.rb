require 'spec_helper'

describe Admin::DomainsController do
  let(:current_site) { mock_model(Site, :id => "1", :name => "foobar").as_null_object }
  let(:current_user) { logged_in(:role? => "admin", :site_id => current_site.id) }

  before(:each) do
    current_site.stub(:users).and_return([current_user])
    cas_faker(current_user.puid)
    stub_c_site_c_user(current_site, current_user)
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
      response.should render_template("admin/domains/new")
    end
  end

  describe "DELETE destroy" do
    let(:params) {{ "site_id" => current_site.to_param, "id" => "0" }}
    let(:domain) { "test.com" }
    let(:domains) { [domain] }

    before(:each) do
      current_site.stub(:domains).and_return(domains)
      Site.stub(:find).and_return(current_site)
    end

    def do_delete
      delete :destroy, params
    end

    it "should assign the current_site" do
      do_delete
      assigns(:current_site).should == current_site
    end
      
    it "should assign the domain" do
      do_delete
      assigns(:domain).should == domain
    end
  end
end
