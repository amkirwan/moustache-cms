require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')   

class FooController < ApplicationController
  def index  
    current_user  
    render :text=> "foo" 
  end
end

describe FooController do      
  before(:each) do   
    Etherweb::Application.routes.draw do
      resources :foo
    end   
    @current_user = mock_model('User') 
    User.stub_chain(:where, :first).and_return(@current_user)
  end      
  
  after(:each) do
    Etherweb::Application.routes.clear!
  end 
  
  def do_get
    get :index, :cas_user => 'foobar'
  end

  describe "handling cancan current_user method" do
    it "should receive current_user" do    
      controller.should_receive(:current_user)
      do_get
    end   
    
    it "should find the current user" do
      User.should_receive(:where)
      do_get
    end
    
    it "current user should return the user" do
      do_get
      assigns[:current_user].should == @current_user
    end 
  end 
end                                    