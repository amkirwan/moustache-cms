# edit css file spec
require "spec_helper"

describe "admin/css_files/edit.html.haml" do
  
  let(:css_file) { mock_model("CssFile", :name => "foobar") }
  let(:current_user) { stub_model(User, :role? => true) }
   
  before(:each) do 
    assign(:css_file, css_file)
    assign(:current_user, current_user)
  end
  
  it "should render form title" do
    render
    rendered.should have_selector("h3", :content => "Edit CSS File #{css_file.name}")
  end
  
  it "should render partial form with button to save new css file" do
    render
    view.should  render_template(:partial => "form", :locals => { :css_file => css_file, :button_label => "Update CSS File" })
  end
  
end