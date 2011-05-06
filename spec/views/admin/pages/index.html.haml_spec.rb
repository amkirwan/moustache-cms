# admin::pages index spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/pages/index.html.haml" do
  let(:current_user) { stub_model(User, :role? => true) }
  let(:parent) { stub_model(Page, :title => "root_node", :parent => nil, :updated_at => Time.now, :updated_by => current_user) }
  let(:pages) { [parent, stub_model(Page, :parent => parent, :title => "foobar", :status => "published", :updated_at => Time.now, :updated_by => current_user) ] }
  
  
  before(:each) do
    assign(:pages, pages)
    assign(:current_user, current_user)
  end
  
  it "should make the layout name a link to edit the page" do
    render
    pages.each do |page|
      rendered.should have_selector("li##{page.title}") do |li|
        li.should have_selector("a", :content => "#{page.title}", :href => edit_admin_page_path(page))
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