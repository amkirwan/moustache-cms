# pages _form spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/pages/_form.html.haml" do
  include FormHelpers
 
  let(:page) { stub_model(Page) }
  let(:current_user) { stub_model(User, :role? => true) }
   
  before(:each) do 
    assign(:page, page)
    assign(:current_user, current_user)
  end
    
  def do_render(label)
    render "admin/pages/form", :page => page, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")   
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => page })
  end      
  
  context "when the page is a new record" do
    
    before(:each) do
      page.as_new_record
    end
    
    def get_new(&block)
      form_new(:action => admin_pages_path) { |f| yield f }
    end
    
    def new_render
      do_render("Create Page")
    end
      
    it "should render a form to create new page" do
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "submit", :value => "Create Page")
      end
    end
    
    it "should render a field to enter the page title" do
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "text", :name => "page[title]")
      end
    end
    
    it "should render a form select" do
      new_render
      get_new do |f|
        f.should have_selector("select", :name => "page[current_state]")
      end
    end
    
    it "should display a layout to use for the page" do
      new_render
      get_new do |f|
        f.should have_selector("select", :name => "page[layout]")
      end
    end
  end                                                                                      
end