# page index spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/pages/index.html.haml" do
  let(:pages) { [stub_model(Page, :title => "foobar", :status => "Published"), stub_model(Page, :title => "bar", :status => "Published")] }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:pages, pages)
    assign(:current_user, current_user)
  end
  
  it "should show the layout name" do
    render
    rendered.should contain("foobar")
  end
  
  it "should make the layout name a link to edit the page" do
    render
    pages.each do |page|
      rendered.should have_selector("tr##{page.title}") do |tr|
        tr.should have_selector("a", :content => "#{page.title}", :href => edit_admin_page_path(page))
      end
    end
  end
  
  it "should render page status" do
    render
    pages.each do |page|
      rendered.should have_selector("tr##{page.title}") do |tr|
        tr.should contain("Published")
      end
    end
  end
  
  it "should display a delete button" do
    render
    pages.each do |page|
      rendered.should have_selector("form", :method => "post", :action => admin_page_path(page)) do |form|
        form.should have_selector("input", :value => "delete")
      end
    end
  end
  
  it "should render a New Layout Link" do
    render
    rendered.should have_selector("a", :href => new_admin_page_path)
    rendered.should contain("Add New Page")
  end
end