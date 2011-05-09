# layout _form spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/layouts/_form.html.haml" do
  include FormHelpers
  
  let(:layout) { stub_model(Layout) }
  let(:current_user) { stub_model(User, :role? => true) }
   
  before(:each) do 
    assign(:layout, layout)
    assign(:current_user, current_user)
  end
  
  def do_render(label)
    render "admin/layouts/form", :layout => layout, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")   
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => layout })
  end
  
  context "when the layout is a new record" do
    
    before(:each) do
      layout.as_new_record
    end
    
    it "should render a form to create a new layout" do
      do_render("Create Layout")
      form_new(:action => admin_layouts_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Create Layout")
      end
    end
    
    it "should show a field to enter the name of the layout" do
      do_render("Create Layout")
      form_new(:action => admin_layouts_path) do |f|
        f.should have_selector("input", :type => "text", :name => "layout[name]")
      end
    end
    
    it "should have a textare to enter the content for they layout" do
      do_render("Create Layout")
      form_new(:action => admin_layouts_path) do |f|
        f.should have_selector("textarea", :name => "layout[content]")
      end
    end
  end
  
  context "when the layout is a existing layout" do
    before(:each) do
      layout.stub(:new_record? => false)
    end
    
    it "should render a form to update the layout" do
      do_render("Update Layout")
      form_update(:action => admin_layout_path(layout)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update Layout")
      end
    end
    
    it "should show a field with the layout name" do
      layout.stub(:name => "foobar")
      do_render("Update Layout")
      form_update(:action => admin_layout_path(layout)) do |f|
        f.should have_selector("input", :type => "text", :value => "foobar")
      end
    end
    
    it "should contain a textarea that has the layout content" do
      layout.stub(:content => "Hello, World!")
      do_render("Update Layout")
      form_update(:action => admin_layout_path(layout)) do |f|
        f.should have_selector("textarea", :content => "Hello, World!")
      end
    end
  end
end