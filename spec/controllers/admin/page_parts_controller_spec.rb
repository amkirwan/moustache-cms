require 'spec_helper'

describe Admin::PagePartsController do

  let(:site) { mock_model(Site) }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:page) { mock_model("Page", :site_id => site.id).as_null_object }
  let(:page_part) { mock_model("PagePart", :name => "page part name", :content => "page part content", :_parent => page) }
  let(:page_parts) { [page_part] }


  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)

    page.stub(:find).and_return(page_parts)
    Page.stub(:find).and_return(page)
  end

  describe "GET /show" do

    before(:each) do
      page.stub_chain(:page_parts, :find).and_return(page_part)
    end

    def do_get
      get :show, :page_id => page.id, :id => page_part.id
    end

    it "should assign the page_part" do
      do_get
      assigns(:page_part).should == page_part
    end

  end

  describe "POST /create" do

    let(:params) { { "name" => "foobar", "content" => "foobar content" } }

    before(:each) do
      page.stub(:page_parts).and_return(page_parts)
      page_parts.stub(:new).and_return(page_part)
      page_part.stub(:filter_name=)
      page_part.stub(:save).and_return(true)      
    end

    def do_post(post_params=params)
      post :create, :page_id => page.id, :page_part => post_params
    end

    it "should create a new page_part from the params" do
      page_parts.should_receive(:new).with(params).and_return(page_part)
      do_post
    end

    context "with valid params" do
      before(:each) do
        page.stub_chain(:page_parts, :push).and_return(page_part)
      end

      it "should assign the flash message" do
        do_post
        flash[:notice].should_not be_empty
      end

      it "should redirect to the page the page_part was created for" do
        do_post
        response.should redirect_to(edit_admin_page_path(page, :view => page_part.name))
      end
    end

    context "with invalid params" do
      before(:each) do
        page_part.stub(:save).and_return(false)
        page_part.stub(:errors => { :page_part => "page_part errors" })
      end

      it "should render the new template when creating the page_part fails" do
        do_post
        response.should render_template("admin/page_parts/new")
      end
    end
  end

# -- Delete Destroy --- 
  describe "DELETE /destroy" do

    let(:params) { {:page_id => page.id, :id => page_part.id} }

    before(:each) do
      page.stub_chain(:page_parts, :find).and_return(page_part)
      page_part.stub(:destroy).and_return(true)
      page_part.stub(:persisted?).and_return(false)
    end

    def do_delete(destroy_params=params)
      delete :destroy, destroy_params
    end

    context "with valid params" do
      it "should destroy the page_part" do
        page_part.should_receive(:destroy).and_return(true)
        do_delete
      end

      it "should set the the flash notice message" do
        do_delete
        flash[:notice].should_not be_empty
      end

      it "should redirect to the page" do
        do_delete
        response.should redirect_to([:edit, :admin, page])
      end
    end
  end

end
