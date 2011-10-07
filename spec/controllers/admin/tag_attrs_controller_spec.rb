require 'spec_helper'

describe Admin::TagAttrsController do

  let(:site) { mock_model(Site) }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:tag_attr) { mock_model("TagAttr", :name => "media" )}
  let(:tag_attrs) { [tag_attr] }
  let(:theme_asset) { mock_model("ThemeAsset", :site_id => site.id, :tag_attrs => tag_attrs)}

  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)

    ThemeAsset.stub(:find).and_return(theme_asset)
  end


  # -- Get New ---
  describe "Get /new" do
    before(:each) do
      tag_attr.as_new_record
      theme_asset.stub_chain(:tag_attrs, :new).and_return(tag_attr)
    end

    def do_get
      get :new, :theme_asset_id => theme_asset.id
    end

    it "should receive new and create a new tag_attr" do
      tag_attrs.should_receive(:new).and_return(tag_attr)
      do_get
    end

    it "should assign the tag_attr for the view" do
      do_get
      assigns(:tag_attr).should == tag_attr
    end

    it "should render the new template" do
      do_get
      response.should render_template("admin/tag_attrs/new")
    end
  end
end

