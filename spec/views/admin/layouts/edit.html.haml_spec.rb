# edit layout spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')


describe "admin/layouts/edit.html.haml" do
  
  let(:layout) { stub_model(Layout, :name => "foobar") }
  
  before(:each) do
    assign(:layout, layout)
  end
  
  it "should show the form title" do
    render
    rendered.should have_selector("h3", :content => "Edit Layout #{layout.name}")
  end
  
  it "should render layout partial" do
    render
    view.should render_template(:partial => "form", :locals => { :layout => layout, :button_label => "Update Layout"})
  end
end