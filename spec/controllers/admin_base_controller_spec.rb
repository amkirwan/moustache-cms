require 'spec_helper'

describe AdminBaseController do

  controller(AdminBaseController) do 
    skip_authorization_check
    def index
      # call admin? method to test
      if admin?
        render :text => 'admin? true', :layout => false 
      else
        render :text => 'admin? false', :layout => false, :status => 404
      end
    end
  end

  describe "admin? method" do
    context "if the user is an admin" do
      before(:each) do
        @current_admin_user = login_admin
      end

      it "should receive admin? method and return true" do
        controller.should_receive(:admin?).and_return(true)
        get :index
      end

      it "should return a status of 200" do
        get :index
        response.code.should == "200"
      end
    end

    context "if the user is not an admin" do
      before(:each) do
        @current_admin_user = login_editor
      end

      it "should receive the admin? method and return false" do
        controller.should_receive(:admin?).and_return(false)
        get :index
      end

      it "should return a status of 404" do
        get :index
        response.code.should == "404"
      end
    end
  end

end


describe AdminBaseController do

  

  controller(AdminBaseController) do 
    skip_authorization_check
    def index   
      # call created_updated_by_for
      created_updated_by_for(Page.new)
      render :nothing => true
    end 
  end
  
  before(:each) do
    @current_admin_user = login_admin
    @page = mock_model(Page, :id => '1', :site_id => @site.id)
  end
  
  describe "created_updated_by method" do
    it "should receive created_updated_by method" do
      controller.should_receive(:created_updated_by_for)
      get :index
    end
  end

end
