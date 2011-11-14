require 'spec_helper'

describe Admin::TagAttrsController do

  let(:site) { mock_model(Site) }
  let(:current_admin_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:tag_attr) { mock_model("TagAttr", :name => "media" )}
  let(:tag_attrs) { [tag_attr] }
  let(:theme_asset) { mock_model("ThemeAsset", :site_id => site.id, :tag_attrs => tag_attrs)}

  before(:each) do
    cas_faker(current_admin_user.puid)
    stub_c_site_c_user(site, current_admin_user)

    ThemeAsset.stub(:find).and_return(theme_asset)
  end


  # -- Get New ---
  describe "GET /new" do
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

  describe "GET /edit" do

    before(:each) do
      theme_asset.stub_chain(:tag_attrs, :find).and_return(tag_attr)
    end

    def do_get
      get :edit, :theme_asset_id => theme_asset.id, :id => tag_attr.id
    end

    it "should assign the tag_attr" do
      do_get
      assigns(:tag_attr).should == tag_attr
    end

    it "should render the edit template" do
      do_get
      response.should render_template("admin/tag_attrs/edit")
    end
  end

  describe "POST /create" do

    let(:params) { {"name" => "media", "content" => "screen" } }

    before(:each) do
      theme_asset.stub_chain(:tag_attrs, :new).and_return(tag_attr)
      tag_attr.stub(:errors => { :tag_attr => "tag_attr errors" })
    end

    def do_post(post_params=params)
      post :create, :theme_asset_id => theme_asset.id, :tag_attr => post_params
    end

    it "should receive create and build a new tag_attr from the params" do
      tag_attrs.should_receive(:new).with(params).and_return(tag_attr)
      do_post
    end

    context "with valid params" do
      before(:each) do
        theme_asset.stub_chain(:tag_attrs, :push).and_return(tag_attr)
      end

      it "should assign a flash message that the tag_attr was created" do
        do_post
        flash[:notice].should == "Successfully created the tag attribute #{tag_attr.name}"
      end

      it "should redirect to the theme_asset the tag attributes were created for" do
        do_post
        response.should redirect_to([:edit, :admin, theme_asset])
      end
    end

    context "with invalid params" do
      before(:each) do
        theme_asset.stub_chain(:tag_attrs, :push).and_return(false)
      end

      it "should render the new template when creating the tag attr fails" do
        do_post
        tag_attr.should render_template("admin/tag_attrs/new")
      end
    end

  end

  # -- PUT Update ---
  describe "PUT /update" do

    let(:params) { {:theme_asset_id => theme_asset.id, :id => tag_attr.id, :tag_attr => { "name" => "media", "content" => "print" }} }

    before(:each) do
      theme_asset.stub_chain(:tag_attrs, :find).and_return(tag_attr)
      tag_attr.stub(:update_attributes).and_return(true)
      tag_attr.stub(:errors => { :tag_attr => "tag_attr errors" })
    end

    def do_put(put_params=params)
      put :update, put_params
    end

    it "should assign tag_attr for the view" do
      do_put
      assigns(:tag_attr).should == tag_attr
    end

    context "with valid params" do
      it "should update the tag_attr successfully" do
        tag_attr.should_receive(:update_attributes).with(params[:tag_attr]).and_return(true)
        do_put
      end

      it "should set the flash message and redirect to the theme_asset" do
        do_put
        flash[:notice].should == "Successfully updated the tag attribute #{tag_attr.name}"
        response.should redirect_to([:edit, :admin, theme_asset])
      end
    end

    context "with invalid params" do
      before(:each) do
        tag_attr.should_receive(:update_attributes).and_return(false)
      end

      it "should render the tag_attr edit view" do
        do_put
        response.should render_template('admin/tag_attrs/edit')
      end
    end
  end

  # -- Delete Destroy --
  describe "DELETE /destroy" do
    let(:params) { {:theme_asset_id => theme_asset.id, :id => tag_attr.id } }

    before(:each) do
      theme_asset.stub_chain(:tag_attrs, :find).and_return(tag_attr)
      tag_attr.stub(:destroy).and_return(true)
      tag_attr.stub(:persisted?).and_return(false)
    end

    def do_delete(delete_params=params)
      delete :destroy, delete_params
    end

    it "should find the tag_attr to destroy" do
      tag_attrs.should_receive(:find).with(tag_attr.id.to_s).and_return(tag_attr)
      do_delete
    end

    context "with valid params" do
      it "should destory the tag_attr" do
        tag_attr.should_receive(:destroy).and_return(true)
        do_delete
      end

      it "should set the flash message and redirct to the theme_asset" do
        do_delete
        flash[:notice].should == "Successfully deleted the tag attribute #{tag_attr.name}"
        response.should redirect_to([:edit, :admin, theme_asset])
      end
    end
  end
end

