require 'spec_helper'

describe Admin::CurrentSiteController do
  let(:current_site) { mock_model(Site, :id => "1") }
  let(:current_user) { logged_in(:role? => "admin", :site_id => current_site.id) }

  before(:each) do
    current_site.stub(:users).and_return([current_user])
    cas_faker(current_user.puid)
    stub_c_site_c_user(current_site, current_user)
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
  

end
