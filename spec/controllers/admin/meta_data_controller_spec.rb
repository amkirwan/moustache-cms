require 'spec_helper'

describe Admin::MetaDataController do

  let(:site) { mock_model(Site) }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:page) { mock_model("Page", :site_id => site.id).as_null_object }

  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)
  end


  # -- Get New ----
  describe "GET /new" do
    def do_get
      get :new, :page_id => page.id
    end

    before(:each) do
      controller.stub(:current_site).and_return(site)
      Page.stub(:find).and_return(page)
    end

    it "should receive create a new hash" do
      #Hash.should_receive(:new).and_return({})
      do_get
    end

  end
end
