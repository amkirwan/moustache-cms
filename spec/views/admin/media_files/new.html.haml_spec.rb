require 'spec_helper'

describe "admin_media_files/new.html.haml" do
  before(:each) do
    assign(:media_file, stub_model(Admin::MediaFile).as_new_record)
  end

  it "renders new media_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_media_files_path, :method => "post" do
    end
  end
end
