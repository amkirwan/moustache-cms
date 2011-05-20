require "spec_helper"

describe "admin/css_files/_form.html.haml" do
  include FormHelpers
  
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:current_user) { stub_model(User, :role? => true) }
  let(:css_file) { stub_model(CssFile) }
  
  before(:each) do
    assign(:current_site, site)
    assign(:current_user, current_user)
    assign(:css_file, css_file)
  end
  
  def do_render(label)
    render "admin/css_files/form", :css_file => css_file, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => css_file })
  end
  
  context "when the css file is NEW" do
    before(:each) do
      css_file.as_new_record
      do_render("Save CSS File")
    end
    
    it "should render a button to save the new css file" do    
      form_new(:action => admin_css_files_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save CSS File")
      end
    end
    
    it "should render a text field to enter the css file name" do
      form_new(:action => admin_css_files_path) do |f|
        f.should have_selector("input", :type => "text", :name => "css_file[name]")
      end
    end
    
    it "should render a textare to enter the css" do
      form_new(:action => admin_css_files_path) do |f|
        f.should have_selector("textarea", :name => "css_file[content]")
      end
    end
  end
end