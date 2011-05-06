require 'spec_helper'

describe "admin_media_files/show.html.haml" do
  before(:each) do
    @media_file = assign(:media_file, stub_model(Admin::MediaFile))
  end

  it "renders attributes in <p>" do
    render
  end
end
