# NEW media_files
require 'spec_helper'

describe "admin/media_files/new.html.haml" do
  let(:media_file) { stub_model(MediaFile) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:media_file, media_file.as_new_record)
    assign(:current_user, current_user)
  end

  it "renders new media_file form" do
    render
    rendered.should have_selector("h3", :content => "Create New Media")
  end
  
  it "should render the form partial" do
    render
    view.should render_template(:partial => "form", :locals => { :media_file => media_file, :button_label => "Save Media" })
  end
end
