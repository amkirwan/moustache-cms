# layout new spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/layouts/new.html.haml" do
  
  let(:layout) { stub_model(Layout).as_new_record }
  let(:current_user) { stub_model(User, :role? => true) }
   
  before(:each) do 
    assign(:layout, layout)
    assign(:current_user, current_user)
  end
  
  it "should render form title" do
    render
    rendered.should have_selector("h3", :content => "Create New Layout")
  end
  
  it "should render partial form" do
    render
    view.should render_template(:partial => "form", :locals => { :layout => layout, :button_label => "Create Layout" })
  end
  
end