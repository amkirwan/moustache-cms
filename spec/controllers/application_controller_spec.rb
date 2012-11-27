require 'spec_helper'

describe "ApplicationController" do

  let(:current_site) { mock_model(Site).as_null_object }

  before(:each) do
    Site.stub(:match_domain).with("test.host").and_return(@criteria_sites = [current_site])
    @criteria_sites.stub(:first).and_return(current_site)
  end

  describe ApplicationController do
    controller do
      def index
        render :text => 'Hello, World', :status => 200
      end
    end

    describe "current_site before_filter" do
           
      context "valid params" do
        
        it "should find the site" do
          get :index  
          assigns(:current_site).should == current_site
        end
        
        it "should respond with 200" do
          get :index
          response.code.should == "200"
        end

        it "should render the text response" do
          get :index
          response.body.should == "Hello, World"
        end
      end
    
      context "invalid params" do
        before(:each) do
          @criteria_sites.stub(:first).and_return(nil)
        end

        it "should not find the site for the page and return 404" do
          get :index
          response.code.should == "404"
        end
      end
    end

  end
end                                

