require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "shared/_error_messages.html.haml" do
  
  def do_render
    render "shared/error_messages", :target => @error_model
  end
  
  before(:each) do
    @error_model = mock_model("SpecErrorModel").as_null_object 
    error = stub("ActiveModel::Errors")
    error.stub(:any?).and_return(true)
    error.stub(:count).and_return(1)
    error.stub(:full_messages).and_return(["Spec Error Message"])
    @error_model.stub(:errors).and_return(error)
  end


  it "should render the error partial" do
    do_render
    rendered.should have_selector("div#error_explanation")
  end
  
  it "should render the number of errors" do
    do_render
    rendered.should have_selector("h2", :content => "1 error prohibited this record from being saved")
  end
  
  it "should render the error message" do
    do_render
    rendered.should have_selector("li", :content => "Spec Error Message")
  end
end