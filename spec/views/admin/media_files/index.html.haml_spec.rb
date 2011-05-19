# admin::media_files index spec
require 'spec_helper'

describe "admin/media_files/index.html.haml" do
  let(:user) { stub_model(User, :puid => "ak730") }
  let(:media_files) { [stub_model(MediaFile, :name => "foobar", :created_by => user), stub_model(MediaFile, :name => "foo", :created_by => user)] }
  
  before(:each) do
    assign(:media_files, media_files)
    view.stub(:can?).and_return(true)
  end

  it "renders a list of admin_media_files" do
    render
    media_files.each do |media|
      rendered.should have_selector("li##{media.name}") do |li|
      end
    end
  end
  
  it "should render a link to edit the file" do
    render
    media_files.each do |media|
      rendered.should have_selector("li##{media.name}") do |li|
        li.should have_selector("div") do |div|
          div.should have_selector("a", :content => "#{media.name}", :href => edit_admin_media_file_path(media))
        end
      end
    end
  end
  
  it "should render the username for the person who created the file" do
    render
    media_files.each do |media|
      rendered.should have_selector("li##{media.name}") do |li|
        li.should have_selector("div", :content => "#{media.created_by.puid}")
      end
    end
  end
  
  it "should render a delete button to destroy the media file" do
    render
    media_files.each do |media|
      rendered.should have_selector("li##{media.name}") do |li|
        li.should have_selector("div") do |div|   
          div.should have_selector("form", :method => "post", :action => admin_media_file_path(media)) do |form|
            form.should have_selector("input", :value => "delete")
          end   
        end
      end
    end
  end
  
  it "should render a link to add a new media file" do
    render
    rendered.should have_selector("ul#new_media_file") do |ul|
      ul.should have_selector("li") do |li|
        li.should have_selector("a", :content => "Add Media File", :href => new_admin_media_file_path)
      end
    end
  end

end
