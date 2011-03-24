# page index spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/pages/index.html.haml" do
  let(:pages) { [stub_model(Page, :title => "foobar", :status => "published", :parent_id => "4d8908d15dfe2f273300005b") ] }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:pages, pages)
    assign(:current_user, current_user)
  end
  
  it "should show the page's parent name when the parent_id is not nil" do
    
    Page.stub_chain(:criteria, :id).with(pages[0].parent_id).and_return(@criteria = mock_model("MongoidCriteria"))
    @criteria.stub(:first => (@page = stub_model(Page)))
    @page.stub(:title => "foobar")
    #Page.stub_chain(:criteria, :id).and_return(@criteria = mock_model("MongoidCriteria"))
    #@criteria.stub(:first).and_return(stub_model(Page, ))
    render
    pages.each do |page|
      rendered.should have_selector("tr##{page.title}") do |tr|
                puts "parent_id=#{page.parent_id.nil?}"
        tr.should contain("#{Page.criteria.id(page.parent_id).title}")
      end
    end
  end
  
  it "should not show the page's parent name when the parent_id is nil" do
    pages[0].stub(:parent_id).and_return(nil)
    render
    pages.each do |page|
      render.should have_selector("tr##{page.title}") do |tr|
      end
    end
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
        tr.should contain("published")
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