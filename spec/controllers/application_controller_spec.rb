require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  controller do
    def index
      render :nothing => true
    end
  end

  describe "handling AccessDenied exceptions" do
    it "redirects to the /401.html page" do 
      mock_model(CASClient::Frameworks::Rails::Filter).as_null_object
      session[:cas_user] = "ak730"
      get :index
      response.should be_redirect
    end
  end
end
#controller.class.skip_before_filter :name_of_method_used_as_before_filter