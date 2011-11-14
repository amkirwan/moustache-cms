# page new spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/pages/new.html.haml" do
  
  let(:page) { stub_model(Page) }
  let(:current_admin_user) { stub_model(User, :role? => true) }
  
  before(:each) do 
    assign(:page, page)
    assign(:current_admin_user, current_admin_user)
  end
  
  it "should render form title" do
    render
    rendered.should have_selector("h3", :content => "Create New Page")
  end
  
  it "should render the form partial for a new page" do
    render
    view.should render_template(:partial => "form", :locals => { :page => page, :button_label => "Create Page" })
  end
end