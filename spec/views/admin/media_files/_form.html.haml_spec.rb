require "spec_helper"

describe "admin/media_files/_form.html.haml" do
  include FormHelpers
    
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:media_file) { stub_model(MediaFile) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:current_site, site)
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
    
    it "should render a button to save the new media_file" do    
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save Media")
      end
    end
    
    it "should render a field to enter the name" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "text", :name => "media_file[name]")
      end
    end
    
    it "should render a field to enter a description" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("textarea", :name => "media_file[description]")
      end
    end
    
    it "should render a field to upload file" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "file", :name => "media_file[media_asset]")
      end
    end
    
    it "should render a field for the alt_text" do
      form_new(:action => admin_media_files_path) do |f|
        f.should have_selector("input", :type => "text", :name => "media_file[alt_txt]")
      end
    end
  end
  
  context "when EDITing the media file" do
    before(:each) do
      media_file.stub(:new_record? => false)
    end
    
    it "should render a button to update the media file" do
      do_render("Update File")
      form_update(:action => admin_media_file_path(media_file)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update File")
      end
    end
    
    it "should render a field with the media file name" do
      media_file.stub(:name => "foobar")
      do_render("Update File")
      form_update(:action => admin_media_file_path(media_file)) do |f|
        f.should have_selector("input", :type => "text", :value => "foobar")      
      end
    end
    
    it "should render a field with the description" do
      media_file.stub(:description => "foobar description")
      do_render("Update File")
      form_update(:action => admin_media_file_path(media_file)) do |f|
        f.should have_selector("textarea", :content => "foobar description")
      end
    end
    
    it "should show the location of the file" do
      media_file.stub_chain(:media_asset, :url => "/image/path/file.png")
      do_render("Update File")
      rendered.should have_selector("a", :content => "http://#{site.full_subdomain}#{media_file.media_asset.url}")
    end   
    
    it "should render a field with the alt_text" do
      media_file.stub(:alt_txt => "upload alternate text")
      do_render("Update File")
      form_update(:action => admin_media_file_path(media_file)) do |f|
        f.should have_selector("input", :type => "text", :value => "upload alternate text")
      end
    end   
  end
end