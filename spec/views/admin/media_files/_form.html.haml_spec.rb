require "spec_helper"

describe "admin/media_files/_form.html.haml" do
  include FormHelpers
    
  let(:media_file) { stub_model(MediaFile) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:media_file, media_file)
    assign(:current_user, current_user)
  end
  
  def do_render(label)
    render "admin/media_files/form", :media_file => media_file, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => media_file })
  end
  
  context "when the media file is NEW" do
    before(:each) do
      media_file.as_new_record
      do_render("Save Media")
    end
    
    it "should render a form to create a new media_file " do    
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save Media")
      end
    end
    
    it "should render a field to enter the name" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "text", :name => "media_file[name]")
      end
    end
    
    it "should render a file upload field" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "file", :name => "media_file[url]")
      end
    end
    
    it "should render a field to enter a description" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("textarea", :name => "media_file[description]")
      end
    end
    
    it "should render a field for the alt_text" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "text", :name => "media_file[alt_text]")
      end
    end
  end
end