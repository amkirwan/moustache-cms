# layout index spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/layouts/index.html.haml" do
  let(:layouts) { [stub_model(Layout, :name => "foobar"), stub_model(Layout, :name => "bar")] }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:layouts, layouts)
    assign(:current_user, current_user)
  end
  
  it "should display the layout name" do
    render
    rendered.should contain("foobar")
  end
  
  it "should make the layout name a link to edit the template" do
    render 
    layouts.each do |layout|
      rendered.should have_selector("tr##{layout.name}") do |tr|
        tr.should have_selector("a", :content => "#{layout.name}", :href => edit_admin_layout_path(layout))
      end
    end 
  end
  
  it "should render a delete button to destroy the layout" do
    render
    layouts.each do |layout|
      rendered.should have_selector("form", :method => "post", :action => admin_layout_path(layout)) do |form|
          form.should have_selector("input", :value => "delete")
      end
    end
  end
  
  it "should render a New Layout Link" do
    render
    rendered.should have_selector("a", :href => new_admin_layout_path)
    rendered.should contain("Add New Layout")
  end
end