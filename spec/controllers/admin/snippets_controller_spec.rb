require 'spec_helper'

describe Admin::SnippetsController do

  before(:each) do
    login_admin
    @snippet = mock_model(Snippet, :site_id => @site.id).as_null_object
  end

  describe "GET index" do
    let(:snippets) { [@snippet] }
    
    def do_get
      get :index
    end

    before(:each) do
      Snippet.stub(:accessible_by).and_return(snippets)
      snippets.stub(:where).and_return(snippets)
    end

    it "should assign the snippet" do
      do_get
      assigns[:snippets].should == snippets
    end

    it "should only show the snippet for the site" do
      snippets.should_receive(:where).with(:site_id => @current_admin_user.site_id)
      do_get  
    end

    it "should render the template" do
      do_get
      response.should render_template('admin/snippets/index')
    end
  end

  describe "GET new" do
    def do_get
      get :new
    end

    before(:each) do
      @snippet.as_new_record
      Snippet.stub(:new).and_return(@snippet)
    end

    it "should assign the snippet" do
      do_get
      assigns[:snippet].should == @snippet
    end

    it "should render the template" do
      do_get
      response.should render_template('admin/snippets/new')
    end
  end

  describe "POST create" do
    let(:params) { {'snippet' => {'name' => 'foobar'}} }

    def do_post(post_params=params)
      post :create, post_params
    end

    before(:each) do
      @snippet.as_new_record
      Snippet.stub(:new).and_return(@snippet)
    end

    it "should create a new snippet from the post params" do
      Snippet.should_receive(:new).with(params['snippet']).and_return(@snippet)
      do_post
    end

    it "should assign created_by and updated by to the current user" do
      controller.should_receive(:created_updated_by_for).with(instance_of(Snippet))
      do_post
    end

    it "should assign the snippet" do
      do_post
      assigns[:snippet].should == @snippet
    end

    it "should assign the current site" do
      @snippet.should_receive(:site=).with(instance_of(Site))
      do_post
    end

    context "with valid params" do
      before(:each) do
        @snippet.stub(:save).and_return(true)
      end
      
      it "should save the snippet" do
        @snippet.should_receive(:save).and_return(true)
        do_post
      end

      it "should assign the flash notice message" do
        do_post
        flash[:notice].should_not be_nil
      end

      it "should redirect to the snippet index page" do
        do_post
        response.should redirect_to [:admin, :snippets]
      end
    end

    context "with invalid params" do
      before(:each) do
        @snippet.stub(:save).and_return(false)
        @snippet.stub(:errors => { :anything => "snippet errors" })
      end

      it "should receive save and return false" do
        @snippet.should_receive(:save).and_return(false)
        do_post
      end

      it "should render the edit layout" do
        do_post
        response.should render_template 'admin/snippets/new'
      end
    end
  end


  describe "GET edit" do
    def do_get
      get :edit, :id => @snippet.to_param
    end

    before(:each) do
      Snippet.stub(:find).and_return(@snippet)
    end

    it "should find the snippet" do
      Snippet.should_receive(:find).and_return(@snippet)
      do_get
    end

    it "should assign the snippet" do
      do_get
      assigns[:snippet].should == @snippet
    end

    it "should render the view" do
      do_get
      response.should render_template 'admin/snippets/edit'
    end
  end
  
  describe "PUT update" do
    let(:params) { {'id' => @snippet.to_param, 'snippet' => {'name' => 'foobar'}} }

    def do_put(put_params=params)
      put :update, put_params
    end

    before(:each) do
      Snippet.stub(:find).and_return(@snippet)
    end

    it "should find the snippet" do
      Snippet.should_receive(:find).with(params['id']).and_return(@snippet)
      do_put
    end

    it "should assign the snippet" do
      do_put
      assigns[:snippet].should == @snippet
    end

    it "should call update_by" do
      @snippet.should_receive(:updated_by=).with(@current_admin_user)
      do_put
    end

    context "with valid params" do
      before(:each) do
        @snippet.stub(:update_attributes).and_return(true)
      end

      it "should update the snippet" do
        @snippet.should_receive(:update_attributes).with(params['snippet']).and_return(true)
        do_put
      end

      it "should assign the flash message" do
        do_put
        flash[:notice].should_not be_nil
      end

      it "should redirect to the index page" do
        do_put
        response.should redirect_to [:admin, :snippets]
      end
    end

    context "with invalid params" do
      before(:each) do
        @snippet.stub(:update_attributes).and_return(false)
        @snippet.stub(:errors => { :layout => "snippet errors" })
      end

      it "should not update the snippet" do
        @snippet.should_receive(:update_attributes).with(params['snippet']).and_return(false)
        do_put
      end

      it "should render the edit template" do
        do_put
        response.should render_template 'admin/snippets/edit'
      end
    end
  end

  describe "DELETE destroy" do
    def do_delete
      delete :destroy, :id => @snippet.to_param
    end

    before(:each) do
      Snippet.stub(:find).and_return(@snippet)
    end

    it "should find the snippet" do
      Snippet.should_receive(:find).with(@snippet.to_param).and_return(@snippet)
      do_delete
    end

    it "should assign the snippet" do
      do_delete
      assigns[:snippet].should === @snippet
    end

    it "should destroy the snippet" do
      @snippet.should_receive(:destroy).and_return(true)
      do_delete
    end

    it "should create a flash notice message" do
      do_delete
      flash[:notice].should_not be_nil
    end
  end
 
end
