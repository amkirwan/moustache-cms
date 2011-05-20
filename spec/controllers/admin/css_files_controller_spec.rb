require "spec_helper"

describe Admin::CssFilesController do
  let(:site) { mock_model(Site, :id => "1") }
  let(:current_user) { logged_in(:role? => "admin", :site_id => site.id) }
  let(:css_file) { mock_model("CssFile", :site_id => site.id).as_null_object }
  
  
  before(:each) do
    cas_faker(current_user.puid)
    stub_c_site_c_user(site, current_user)
  end
  
  describe "GET index" do    
    let(:css_files) { [css_file] }
    
    before(:each) do
      CssFile.stub(:accessible_by).and_return(css_files)
    end
    
    def do_get
      get :index
    end
    
    it "should receive accessible_by" do
      CssFile.should_receive(:accessible_by).and_return(css_files)
      do_get
    end
    
    it "should assign the css_files for the view" do
      do_get
      assigns(:css_files).should == css_files
    end
    
    it "should render the index layout" do
      do_get
      response.should render_template("admin/css_files/index")
    end
  end
end