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
    
    it "should render a field to enter the page path" do
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "text", :name => "page[path_name]")
      end
    end
    
    it "should render a field to enter the breadcrumb name" do
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "text", :name => "page[breadcrumb]")
      end
    end
    
    it "should render a field to enter the editors" do
      User.stub(:all).and_return([mock_model("User", :puid => "foobar")])
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "checkbox", :name => "page[editor_ids][]")
      end
    end
    
    it "should render a text field for the meta_title" do
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "text", :name => "page[meta_title]")
      end
    end
    
    it "should render a text field for the meta_keywords" do
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "text", :name => "page[meta_keywords]")
      end
    end
    
    it "should render a textarea for the meta_description" do
      new_render
      get_new do |f|
        f.should have_selector("textarea", :name => "page[meta_description]")
      end
    end
    
    it "should render a form select for page layout" do
      Layout.stub(:all).and_return([mock_model("Layout", :name => "foobar" )])
      new_render
      get_new do |f|
        f.should have_selector("select", :name => "page[layout_id]")
      end
    end
    
    it "should render a form select for filter" do
      new_render
      get_new do |f|
        f.should have_selector("select", :name => "page[filter]")
      end
    end
    
    it "should render a form select for page current_state" do
      page.stub(:current_state).and_return(mock_model("CurrentState"))
      new_render
      get_new do |f|
        f.should have_selector("select", :name => "page[current_state_attributes][id]")
      end
    end
    
    it "should render a form text field for tags" do
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "text", :name => "page[tag_list]")
      end
    end
    
    it "should render a form text field for the page part name" do
      page.stub(:page_parts).and_return([ mock_model("PagePart").as_null_object.as_new_record ])
      new_render
      get_new do |f|
        f.should have_selector("input", :type => "text", :name => "page[page_parts_attributes][0][name]")
      end
    end
    
    it "should render a form text area for the page part content" do
      page.stub(:page_parts).and_return([ mock_model("PageParts").as_null_object.as_new_record ])
      new_render
      get_new do |f|
        f.should have_selector("textarea" , :name => "page[page_parts_attributes][0][content]")
      end
    end
  end                                                                                      
end