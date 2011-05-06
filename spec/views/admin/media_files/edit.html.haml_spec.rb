require 'spec_helper'

describe "admin_media_files/edit.html.haml" do
  before(:each) do
    @media_file = assign(:media_file, stub_model(Admin::MediaFile))
  end

  it "renders the edit media_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_media_files_path(@media_file), :method => "post" do
    end
  end
end
