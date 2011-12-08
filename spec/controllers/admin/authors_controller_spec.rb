require 'spec_helper'


describe Admin::AuthorsController do 

  before(:each) do
    login_admin
    @authors = mock_model(Author, :site_id => @site.id).as_null_object
  end


  describe "Get index" do
    let(:authors) { [@authors] }
    
    before(:each) do
      Author.stub(:accessible_by).and_return(authors)
    end
    
    def do_get
      get :index      
    end
    
    it "should receive Author#accessible_by and return asset_collection" do
      Author.should_receive(:accessible_by).and_return(authors)
      do_get
    end
    
    it "should assign authors" do
      do_get
      assigns(:authors).should == authors
    end
    
    it "should render in the index template" do
      do_get
      response.should render_template("admin/authors/index")
    end
  end
end
