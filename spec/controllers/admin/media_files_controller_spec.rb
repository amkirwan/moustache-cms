require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe Admin::MediaFilesController do

  #for actions
  let(:current_user) { logged_in(:role? => true) }
  let(:media_file) { mock_model("MediaFile").as_null_object }
  
  before(:each) do
    cas_faker(current_user.puid)
  end

  # -- GET Index ----------------------------------------------- 
  describe "GET index" do
    def do_get     
      get :index
    end
    
    let(:media_files) { [mock_model("MediaFile"), mock_model("MediaFile")] }
    
    before(:each) do
      MediaFile.stub(:accessible_by).and_return(media_files)
    end
    
    
    it "should receive accessible_by" do
      MediaFile.should_receive(:accessible_by).and_return(media_files)
      do_get
    end
    
    it "should assign the found media_files" do
      do_get
      assigns(:media_files).should == media_files
    end
    
    it "should render the index template" do
      do_get
      response.should render_template("admin/media_files/index")
    end
  end
  
  describe "GET new" do
    def do_get
      get :new
    end
    
    before(:each) do
      media_file.as_new_record
      MediaFile.stub(:new).and_return(media_file)
    end
    
    it "should receive new and return a new media_file" do
      MediaFile.should_receive(:new).and_return(media_file)
      do_get
    end
    
    it "should assign the new media_file for the view" do
      do_get
      assigns(:media_file).should == media_file
    end
    
    it "should render the new template" do
      do_get
      response.should render_template("admin/media_files/new")
    end
  end
  
  describe "POST create" do
    before(:each) do
      media_file.as_new_record
      MediaFile.stub(:new).and_return(media_file)
    end
    
    def do_post(params={})
      post :create, "media_file" => params
    end
    
    it "should create a new media_file from the params" do
      MediaFile.should_receive(:new).with({"these" => "params"}).and_return(media_file)
      do_post({ "these" => "params" })
    end
    
    it "should assign the @media_file for the view" do
      do_post
      assigns(:media_file).should == media_file
    end
    
    it "should assign created_by and updated_by to the current user" do
      controller.should_receive(:created_updated_by_for).with(media_file)
      do_post
    end
      
    context "with valid params" do
      it "should receive and save the media_file" do
        media_file.should_receive(:save).and_return(true)
        do_post
      end
      
      it "should assign a flash message that the media_file was saved" do
        do_post
        flash[:notice].should == "Successfully created the media file #{media_file.name}"
      end
      
      it "should redirect to the admin/media_files/index" do
        do_post
        response.should redirect_to(admin_media_files_path)
      end
    end
    
    context "with invalid params" do
      before(:each) do
        media_file.stub(:save).and_return(false)
      end
      
      it "should receive save and return false" do
        media_file.should_receive(:save).and_return(false)
        do_post
      end
      
      it "should render the new template" do
        do_post
        response.should render_template("admin/media_files/new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested media_file" do
        Admin::MediaFile.stub(:find).with("37") { mock_media_file }
        mock_admin_media_file.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :media_file => {'these' => 'params'}
      end

      it "assigns the requested media_file as @media_file" do
        Admin::MediaFile.stub(:find) { mock_media_file(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:media_file).should be(mock_media_file)
      end

      it "redirects to the media_file" do
        Admin::MediaFile.stub(:find) { mock_media_file(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_media_file_url(mock_media_file))
      end
    end

    describe "with invalid params" do
      it "assigns the media_file as @media_file" do
        Admin::MediaFile.stub(:find) { mock_media_file(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:media_file).should be(mock_media_file)
      end

      it "re-renders the 'edit' template" do
        Admin::MediaFile.stub(:find) { mock_media_file(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested media_file" do
      Admin::MediaFile.stub(:find).with("37") { mock_media_file }
      mock_admin_media_file.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin_media_files list" do
      Admin::MediaFile.stub(:find) { mock_media_file }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_media_files_url)
    end
  end

end