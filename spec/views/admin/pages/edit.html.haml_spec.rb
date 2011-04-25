# edit page spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')


describe "admin/pages/edit.html.haml" do
  
  let(:page) { stub_model(Page, :title => "Page") }
  
  before(:each) do
    assign(:page, page)
  end
  
  it "should show the form title" do
    render
    rendered.should have_selector("h3", :content => "Update Page #{page.title}")
  end
  
  it "should render layout partial" do
    render
    view.should render_template(:partial => "form", :locals => { :page => page, :button_label => "Update Page"})
  end
end