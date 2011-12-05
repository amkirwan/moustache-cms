require 'spec_helper'

describe Admin::ArticleCollectionsController do

  before(:each) do
    login_admin
    @article_colletion = mock_model(ArticleCollection, :site_id => @site.id).as_null_object
  end
  
  describe "GET index" do    
    let(:article_collections) { [@article_collection] }
      
    before(:each) do
      ArticleCollection.stub(:accessible_by).and_return(article_collections)
    end
    
    def do_get
      get :index
    end
      
    it "should receive accessible_by" do
      ArticleCollection.should_receive(:accessible_by).and_return(article_collections)
      do_get
    end
    
    it "should assign the found layouts" do
      do_get
      assigns(:article_collections).should == article_collections
    end
    
    it "should render the index template" do
      do_get
      response.should render_template("admin/article_collections/index")
    end
  end
 

end
