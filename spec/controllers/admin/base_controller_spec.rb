require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')  

describe "Admin::BaseController" do
  let(:current_user) { logged_in(:role? => true) }
  
  controller(Admin::BaseController) do   
    def index 
      render :nothing => true
    end 
  end
  
  before(:each) do
    cas_faker(current_user.username)
  end
  
  describe "cms_site before_filter" do
    it "should receive before_filter cms_site" do
      controller.should_receive(:etherweb_site)
      get :index
    end
  end
end
