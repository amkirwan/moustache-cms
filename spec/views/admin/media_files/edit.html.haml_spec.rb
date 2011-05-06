require 'spec_helper'

describe "admin/media_files/edit.html.haml" do
  let(:media_file) { stub_model(MediaFile, :name => "foobar") }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:media_file, media_file)
    assign(:current_user, current_user)
  end

  it "renders the edit media_file form" do
    render
    rendered.should have_selector("h3", :content => "Edit Media File #{media_file.name.humanize}")
  end
  
  it "should render the form partial to edit the media file" do
    render
    view.should render_template(:partial => "form", :locals => {:media_file => media_file, :button_label => "Update File" })
  end
end
