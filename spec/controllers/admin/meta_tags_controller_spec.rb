require 'spec_helper'

describe Admin::MetaTagsController do

  let(:site) { mock_model(Site) }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:page) { mock_model("Page", :site_id => site.id).as_null_object }
  let(:meta_tag) { mock_model("MetaTag", :name => "DC.author", :_parent => page) }
  let(:meta_tags) { [meta_tag] }


  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)

    page.stub(:meta_tags).and_return(meta_tags)
    Page.stub(:find).and_return(page)
  end


  # -- Get New ----
  describe "GET /new" do

    before(:each) do
      meta_tag.as_new_record
      page.stub_chain(:meta_tags, :new).and_return(meta_tag)
    end

    def do_get
      get :new, :page_id => page.id
    end

    it "should receive create a new hash" do
      meta_tags.should_receive(:new).and_return(meta_tag)
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

  # -- Get Edit
  describe "GET /EDIT" do

    before(:each) do
      page.stub_chain(:meta_tags, :find).and_return(meta_tag)
    end 

    def do_get
      get :edit, :page_id => page.id, :id => meta_tag.id
    end

    it "should assign the meta_tag" do
      do_get
      assigns(:meta_tag).should == meta_tag
    end

    it "should render the template admin/meta_tags/edit" do
      do_get
      response.should render_template("admin/meta_tags/edit")
    end

  end

  # -- Post Create ----
  describe "POST /create" do

    let(:params) { {"name" => "DC.author", "content" => "Foobar Baz"} }

    before(:each) do
      page.stub_chain(:meta_tags, :new).and_return(meta_tag)
    end

    def do_post(post_params=params)
      post :create, :page_id => page.id, :meta_tag => post_params 
    end

    it "should receive build a new meta_tag from the params" do
      meta_tags.should_receive(:new).with(params).and_return(meta_tag)
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

    context "with invalid params" do
      before(:each) do
        page.stub_chain(:meta_tags, :push).and_return(false)
      end

      it "should render the new template when creating the meta_tag fails" do
        do_post
        page.should render_template("admin/meta_tags/new")
      end
    end
  end


  # -- Put Update ---
  describe "PUT /update" do

    let(:params) { {:page_id => page.id, :id => meta_tag.id, :meta_tag => {"name" => "DC.author", "content" => "Foo Bar"}} }

    before(:each) do
      page.stub_chain(:meta_tags, :find).and_return(meta_tag)
      meta_tag.stub(:update_attributes).and_return(true)
    end

    def do_put(put_params=params)
      post :update, put_params
    end

    it "should assign @meta_tag for the view" do
      do_put
      assigns(:meta_tag).should == meta_tag
    end

    it "should find the meta_tag to update" do
      meta_tags.should_receive(:find).and_return(meta_tag)
      do_put
    end
    
    context "with valid params" do
      
      it "should receive update_attributes successfully" do
        meta_tag.should_receive(:update_attributes).with(params[:meta_tag]).and_return(true)
        do_put
      end

      it "should redirect back to the page" do
        do_put
        response.should redirect_to([:edit, :admin, page])
      end

      it "should set the the flash notice message" do
        do_put
        flash[:notice].should == "Successfully updated the meta tag #{meta_tag.name}"
      end
    end

    context "with invalid params" do
      before(:each) do
        meta_tag.should_receive(:update_attributes).and_return(false)
      end

      it "should render the meta_tag edit view" do
        do_put
        response.should render_template("admin/meta_tags/edit")
      end
    end
  end

  # -- Delete Destroy --- 
  describe "DELETE /destroy" do

    let(:params) { {:page_id => page.id, :id => meta_tag.id} }

    before(:each) do
      page.stub_chain(:meta_tags, :find).and_return(meta_tag)
      meta_tag.stub(:destroy).and_return(true)
    end

    def do_delete(destroy_params=params)
      delete :destroy, destroy_params
    end

    it "should find the meta_tag to destroy" do
      meta_tags.should_receive(:find).and_return(meta_tag)
      do_delete
    end

    context "with valid params" do
      it "should destroy the meta_tag" do
        meta_tag.should_receive(:destroy).and_return(true)
        do_delete
      end

      it "should redirect to the page" do
        do_delete
        response.should redirect_to([:edit, :admin, page])
      end

      it "should set the the flash notice message" do
        do_delete
        flash[:notice].should == "Successfully deleted the meta tag #{meta_tag.name}"
      end
    end

  end
end
