require 'spec_helper'

describe Admin::MetaTagsController do

  let(:site) { mock_model(Site) }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:meta_tag) { mock_model("MetaTag", :name => "DC.author") }
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


  # -- Post Create ----
  describe "POST /create" do

    let(:params) { {"name" => "DC.author", "content" => "Foobar Baz"} }

    before(:each) do
      MetaTag.stub(:new).and_return(meta_tag)
    end

    def do_post(post_params=params)
      post :create, :page_id => page.id, :meta_tag => post_params 
    end

    it "should create a new meta tag from the params" do
      MetaTag.should_receive(:new).with(params).and_return(meta_tag)
      do_post
    end

    context "with valid params" do
      before(:each) do
        page.stub_chain(:meta_tags, :push).and_return(meta_tag)
      end

      it "should assign a flash message that the meta_tag was created" do
        do_post
        flash[:notice].should == "Successfully created meta tag #{meta_tag.name}"
      end

      it "should redirect to the page the meta tags were created for" do
        do_post
        response.should redirect_to([:edit, :admin, page])
      end
    end

  end
end
