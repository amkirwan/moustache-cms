require 'spec_helper'

describe Admin::MetaTagsController do

  let(:site) { mock_model(Site) }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:meta_tag) { mock_model("MetaTag") }
  let(:meta_tags) { [meta_tag] }
  let(:page) { mock_model("Page", :site_id => site.id).as_null_object }

  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)
    Page.stub(:find).and_return(page)
  end


  # -- Get New ----
  describe "GET /new" do

    before(:each) do
      MetaTag.stub(:new).and_return(meta_tag.as_new_record)
    end

    def do_get
      get :new, :page_id => page.id
    end

    it "should receive create a new hash" do
      MetaTag.should_receive(:new).and_return(meta_tag)
      do_get
    end

    it "should assing the meta tag for the view" do
      do_get
      assigns(:meta_tag).should == meta_tag
    end

    it "should render the new template" do
      do_get
      response.should render_template("admin/meta_tags/new")
    end

  end
end
