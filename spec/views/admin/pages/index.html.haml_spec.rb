# admin::pages index spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/pages/index.html.haml" do
  let(:current_user) { stub_model(User, :role? => true) }
  let(:parent) { stub_model(Page, :title => "home_page", :parent => nil, :updated_at => Time.now, :updated_by => current_user) }
  let(:pages) { [parent, stub_model(Page, :parent => parent, :title => "foobar", :status => "published", :updated_at => Time.now, :updated_by => current_user) ] }
  
  
  before(:each) do
    assign(:pages, pages)
    assign(:current_user, current_user)
    view.stub(:can?).and_return(true)
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
      rendered.should have_selector("a", :content => "Delete", :href => admin_page_path(page))
    end
  end
  
  it "should render a New Layout Link" do
    render
    rendered.should have_selector("a", :href => new_admin_page_path)
    rendered.should contain("Add New Page")
  end
  
  it "should not render a delete link to the page if can? returns false" do
    view.stub(:can?).and_return(false)
    render
    pages.each do |page|
      rendered.should_not have_selector("a", :content => "Delete", :href => admin_page_path(page))
    end
  end
end