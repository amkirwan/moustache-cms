# layout index spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/layouts/index.html.haml" do
  let(:layouts) { [stub_model(Layout, :name => "foobar"), stub_model(Layout, :name => "bar")] }
  let(:current_admin_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:layouts, layouts)
    assign(:current_admin_user, current_admin_user)
    view.stub(:can?).and_return(true)
  end
  
  it "should display the layout name" do
    render
    rendered.should contain("foobar")
  end
  
  it "should make the layout name a link to edit the template" do
    render 
    layouts.each do |layout|
      rendered.should have_selector("li##{layout.name}") do |li|
        li.should have_selector("a", :content => "#{layout.name}", :href => edit_admin_layout_path(layout))
      end
    end 
  end
  
  it "should render a delete link to destroy the layout" do
    render
    layouts.each do |layout|
      rendered.should have_selector("li##{layout.name}") do |li|
        li.should have_selector("a", :content => "Delete", :href => admin_layout_path(layout))
      end
    end
  end
  
  it "should render a New Layout Link" do
    render
    rendered.should have_selector("a", :href => new_admin_layout_path)
    rendered.should contain("Add New Layout")
  end
  
  it "should not render a delete link to layout if can? returns false" do
    view.stub(:can?).and_return(false)
    render
    layouts.each do |layout|
      rendered.should have_selector("li##{layout.name}") do |li|
        li.should_not have_selector("a", :content => "Delete", :href => admin_layout_path(layout))
      end
    end
  end
end